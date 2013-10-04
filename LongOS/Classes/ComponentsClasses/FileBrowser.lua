local Component = Classes.Components.Component;
local VerticalScrollBar = Classes.Components.VerticalScrollBar; 
local HorizontalScrollBar = Classes.Components.HorizontalScrollBar; 
local EventHandler = Classes.System.EventHandler;

Classes.Components.FileBrowser = Class(Component, function(this, _width, _height, _dX, _dY, _anchor)
	Component.init(this, _dX, _dY, _anchor);

	function this:GetClassName()
		return 'FileBrowser';
	end

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local fileAssotiationConfiguration;

	local width;
	local height;
	local backgroundColor;

	local currentDirectory;
	local selectedFile;

	local filesList;

	local vScrollBar;
	local hScrollBar;

	local onCurrentDirectoryChanged;
	local onFileLaunch;
	local onFileRightClick;
	local onSelectionChanged;

	local filesFilter;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function isDirectory(_name)
		local currentFile = currentDirectory..'/'.._name;
		return fs.isDir(currentFile) or _name == '..';
	end

	local function getFiles()
		local rawFiles =  fs.list(currentDirectory);

		local files;
		if (filesFilter == nil) then
			files = rawFiles;
		else
			files = {};
			for i = 1, #rawFiles do
				if (isDirectory(rawFiles[i]) or filesFilter(currentDirectory, rawFiles[i])) then
					table.insert(files, rawFiles[i]);
				end
			end
		end

		table.insert(files, '..');
		table.sort(files);


		return files;
	end

	local function orderFiles(_filesList)
		local newList = {};
		table.sort(_filesList);
		for i = 1, #_filesList do
			if (isDirectory(_filesList[i])) then
				table.insert(newList, _filesList[i]);
			end
		end

		for i = 1, #_filesList do
			if (not isDirectory(_filesList[i])) then
				table.insert(newList, _filesList[i]);
			end
		end

		return newList;
	end

	local function fireOnCurrentDirectoryChanged()
		onCurrentDirectoryChanged:Invoke(this, { });
	end

	local function fireOnSelectionChanged()
		onSelectionChanged:Invoke(this, { });
	end

	local function fireOnFileLaunch(_fileName)
		onFileLaunch:Invoke(this, { _fileName });
	end

	local function fireOnFileRightClick(_fileName, _cursorX, _cursorY)
		local eventArgs = {};
		eventArgs.FilePath = _fileName;
		eventArgs.X = _cursorX;
		eventArgs.Y = _cursorY;
		onFileRightClick:Invoke(this, eventArgs);
	end

	function this:GetCurrentDirectory()
		return currentDirectory;
	end

	function this:SetCurrentDirectory(_value)
		if (type(_value) ~= 'string') then
			error('FileBrowser.SetCurrentDirectory [value]: String expected, got '..type(_value)..'.');
		end

		if (not fs.isDir(_value)) then
			error('FileBrowser.SetCurrentDirectory [value]: Directory path extected, got string.');
		end

		currentDirectory = _value;
		fireOnCurrentDirectoryChanged();

		filesList = orderFiles(getFiles());
	end

	function this:GetSelectedFile()
		return selectedFile;
	end

	function this:SetSelectedFile(_value)
		if (type(_value) ~= 'string') then
			error('FileBrowser.SetSelectedFile [value]: String expected, got '..type(_value)..'.');
		end

		if (not tableExtAPI.contains(filesList, _value)) then
			error('FileBrowser.SetSelectedFile [value]: File with name "'.._value..'" not found in current directory.');
		end

		selectedFile = _value;
		fireOnSelectionChanged();
	end

	function this:GetWidth()
		return width;
	end

	function this:SetWidth(_value)
		if (type(_value) ~= 'number') then
			error('FileBrowser.SetWidth [value]: Number expected, got '..type(_value)..'.');
		end

		width = _value;
	end

	function this:GetHeight()
		return height;
	end

	function this:SetHeight(_value)
		if (type(_value) ~= 'number') then
			error('FileBrowser.SetHeight [value]: Number expected, got '..type(_value)..'.');
		end

		height = _value;
	end

	function this:GetBackgroundColor()
		return backgroundColor;
	end

	function this:SetBackgroundColor(_value)
		if (type(_value) ~= 'number') then
			error('FileBrowser.SetBackgroundColor [value]: Number expected, got '..type(_value)..'.');
		end

		backgroundColor = _value;
	end

	function this:GetFilesFilter()
		return filesFilter;
	end

	function this:SetFilesFilter(_value)
		if (type(_value) ~= 'function') then
			error('FileBrowser.SetFilesFilter [value]: Function expected, got '..type(_value)..'.');
		end

		filesFilter = _value;
	end

	function this:AddOnCurrentDirectoryChangedEventHandler(_value)
		onCurrentDirectoryChanged:AddHandler(_value);
	end

	function this:AddOnSelectionChangedEventHandler(_value)
		onSelectionChanged:AddHandler(_value);
	end

	function this:AddOnFileLaunchEventHandler(_value)
		onFileLaunch:AddHandler(_value);
	end

	function this:AddOnFileRightClickEventHandler(_value)
		onFileRightClick:AddHandler(_value);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function getDrawingPanelWidth()
		if (vScrollBar:GetVisible()) then
			return this:GetWidth() - 1;
		end

		return this:GetWidth();
	end

	local function getDrawingPanelHeight()
		if (hScrollBar:GetVisible()) then
			return this:GetHeight() - 2;
		end

		return this:GetHeight() - 1;
	end

	local function drawFiles(_videoBuffer, _x, _y)
		filesList = orderFiles(getFiles());
		
		_videoBuffer:SetBackgroundColor(backgroundColor);
		
		local lastLine = #filesList;
		if (lastLine > getDrawingPanelHeight() + vScrollBar:GetValue()) then
			lastLine = getDrawingPanelHeight() + vScrollBar:GetValue();
		end
		for i = vScrollBar:GetValue() + 1, lastLine do
			_videoBuffer:SetCursorPos(_x, i + _y - vScrollBar:GetValue());

			local currentFile = currentDirectory..'/'..filesList[i];
			if (fs.isDir(currentFile) or filesList[i] == '..') then
				if (filesList[i] ~= '..') then
					_videoBuffer:SetBackgroundColor(colors.yellow);
					_videoBuffer:SetTextColor(colors.black);
					_videoBuffer:Write('F');
				end
				_videoBuffer:SetTextColor(colors.blue);
			else
				local assotiation = fileAssotiationConfiguration:GetAssotiation(stringExtAPI.getExtension(filesList[i]));
				if (assotiation ~= nil) then
					_videoBuffer:SetBackgroundColor(assotiation.IconBackgroundColor);
					_videoBuffer:SetTextColor(assotiation.IconTextColor);
					_videoBuffer:Write(assotiation.IconSymbol);
					_videoBuffer:SetTextColor(assotiation.FileNameColor);
				else
					_videoBuffer:SetBackgroundColor(colors.black);
					_videoBuffer:SetTextColor(colors.white);
					_videoBuffer:Write('f');
					_videoBuffer:SetTextColor(colors.green);
				end
			end

			if (selectedFile == filesList[i]) then
				local colorConfiguration = System:GetColorConfiguration();
				_videoBuffer:SetBackgroundColor(colorConfiguration:GetColor('SelectedBackgroundColor'));
			else
				_videoBuffer:SetBackgroundColor(backgroundColor);
			end

			local fileToPrint = filesList[i]
			if (fileToPrint ~= '..') then
				fileToPrint = ''..fileToPrint:sub(hScrollBar:GetValue(), getDrawingPanelWidth() - 3 + hScrollBar:GetValue());
			end

			_videoBuffer:Write(' '..fileToPrint);
		end
	end

	local function findCurrentDirectoryToPrint()
		local currentDirectoryToPrint = currentDirectory;
		if (string.len(currentDirectoryToPrint) > width - 4) then
			local toCut = string.len(currentDirectoryToPrint) - width + 12;
			currentDirectoryToPrint = '...'..string.sub(currentDirectoryToPrint, toCut, string.len(currentDirectoryToPrint));
		end

		return currentDirectoryToPrint;
	end

	local function drawCurrentDirectory(_videoBuffer, _x, _y)
		_videoBuffer:DrawBlock(_x, _y, width, 1, colors.blue);

		_videoBuffer:SetColorParameters(colors.white, colors.blue);
		local currentDirectoryToPrint = findCurrentDirectoryToPrint();
		_videoBuffer:WriteAt(_x + 1, _y, currentDirectoryToPrint);
	end

	local function getMaxFileLength()
		local maxLength = filesList[1]:len();
		for i = 2, #filesList do
			if (filesList[i]:len() > maxLength) then
				maxLength = filesList[i]:len();
			end
		end

		return maxLength;
	end

	local function drawComponents(_videoBuffer, _x, _y)
		if (#filesList > 1) then
			vScrollBar:SetMaxValue(#filesList - getDrawingPanelHeight() + 1);
		else
			vScrollBar:SetMaxValue(1);
		end
		vScrollBar:SetHeight(getDrawingPanelHeight());
		vScrollBar:SetVisible(#filesList + 2 > getDrawingPanelHeight() + 1);

		local maxLength = getMaxFileLength();
		hScrollBar:SetMaxValue(maxLength - getDrawingPanelWidth() + 4);
		hScrollBar:SetWidth(getDrawingPanelWidth());
		hScrollBar:SetVisible(maxLength > getDrawingPanelWidth());

		vScrollBar:DrawBase(_videoBuffer, _x, _y, width, height);
		hScrollBar:DrawBase(_videoBuffer, _x, _y, width, height);
	end

	function this:Draw(_videoBuffer, _x, _y)
		_videoBuffer:DrawBlock(_x, _y, width, height, backgroundColor);
		drawFiles(_videoBuffer, _x, _y);
		drawCurrentDirectory(_videoBuffer, _x, _y);

		drawComponents(_videoBuffer, _x, _y);
	end

	local function processFileSelection(_cursorX, _cursorY)
		if (_cursorX < this:GetX() + width - 3) then
			local clickedLine = _cursorY - this:GetY() + vScrollBar:GetValue();
			if (filesList[clickedLine] ~= nil) then
				if (filesList[clickedLine] == '..') then
					selectedFile = '';
					fireOnSelectionChanged();
				else
					this:SetSelectedFile(filesList[clickedLine]);
				end
			else
				selectedFile = '';
				fireOnSelectionChanged();
			end
		end
	end

	function this:ProcessLeftClickEvent(_cursorX, _cursorY)
		if (this:Contains(_cursorX, _cursorY)) then
			if (vScrollBar:ProcessLeftClickEventBase(_cursorX, _cursorY)) then
				return true;
			end
			if (hScrollBar:ProcessLeftClickEventBase(_cursorX, _cursorY)) then
				return true;
			end

			processFileSelection(_cursorX, _cursorY);

			return true;
		end
	end

	function this:ProcessRightClickEvent(_cursorX, _cursorY)
		if (this:Contains(_cursorX, _cursorY)) then
			if (vScrollBar:ProcessRightClickEventBase(_cursorX, _cursorY)) then
				return true;
			end
			if (hScrollBar:ProcessRightClickEventBase(_cursorX, _cursorY)) then
				return true;
			end

			processFileSelection(_cursorX, _cursorY);

			if (selectedFile ~= '') then
				fireOnFileRightClick(currentDirectory..'/'..selectedFile, _cursorX, _cursorY);
			end

			return true;
		end
	end

	function this:ProcessMouseScrollEvent(_direction, _cursorX, _cursorY)
		if (this:Contains(_cursorX, _cursorY)) then
			if (hScrollBar:Contains(_cursorX, _cursorY) or not vScrollBar:GetVisible()) then
				if (_direction == -1) then
					hScrollBar:ScrollLeft();
				else
					hScrollBar:ScrollRight();
				end
			else
				if (_direction == -1) then
					vScrollBar:ScrollUp();
				else
					vScrollBar:ScrollDown();
				end
			end

			return true;			
		end

		return false;
	end

	local function back()
		selectedFile = '';
		fireOnSelectionChanged();
		vScrollBar:SetValue(0);
		hScrollBar:SetValue(0);
		if (currentDirectory ~= '/') then
			local i = string.len(currentDirectory);
			local endPos = 0;
			while (i >= 1 and endPos == 0) do
				if (string.sub(currentDirectory, i, i) == '/') then
					endPos = i;
				end
				i = i - 1;
			end
			this:SetCurrentDirectory(''..string.sub(currentDirectory, 1, endPos - 1));
		end
	end

	function this:ProcessDoubleClickEvent(_cursorX, _cursorY)
		if (this:Contains(_cursorX, _cursorY)) then
			local clickedLine = _cursorY - this:GetY() + vScrollBar:GetValue();

			if (filesList[clickedLine] ~= nil) then
				local clickedFile = currentDirectory..'/'..filesList[clickedLine];
				if (filesList[clickedLine] == '..') then
					back();
				elseif (fs.isDir(clickedFile)) then
					this:SetCurrentDirectory(clickedFile);
					vScrollBar:SetValue(0);
					hScrollBar:SetValue(0);
					selectedFile = '';
					fireOnSelectionChanged();
				else
					fireOnFileLaunch(clickedFile);
				end
			end

			return true;
		end
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		vScrollBar = VerticalScrollBar(0, 10, height - 1, nil, nil, 0, 1, 'right-top');
		hScrollBar = HorizontalScrollBar(1, 10, width - 1, nil, nil, 0, 0, 'left-bottom');
	end

	local function constructor(_width, _height)
		if (type(_width) ~= 'number') then
			error('FileBrowser.Constructor [width]: Number expected, got '..type(_value)..'.');
		end
		if (type(_height) ~= 'number') then
			error('FileBrowser.Constructor [height]: Number expected, got '..type(_value)..'.');
		end

		width = _width;
		height = _height;
		currentDirectory = '/'
		selectedFile = '';
		filesList = {};
		filesFilter = nil;
		backgroundColor = colors.white;

		onCurrentDirectoryChanged = EventHandler();
		onFileLaunch = EventHandler();
		onSelectionChanged = EventHandler();
		onFileRightClick = EventHandler();

		fileAssotiationConfiguration = System:GetFileAssotiationsConfiguration();

		initializeComponents();
	end

	constructor(_width, _height);
end)
FileManagerWindow = Class(Window, function(this, _application)

	Window.init(this, _application, 'Gvin file manager', false, false, 'Gvin file manager', 5, 3, 40, 12, nil, true, true);

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local currentDirectory;
	local selectedFile;
	local copiedFile;
	local cuttedFile;

	local vScrollBar;
	local pasteButton;
	local createDirectoryButton;
	local contextMenu;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function getFiles()
		local files =  fs.list(currentDirectory);
		table.insert(files, '..');
		table.sort(files);
		return files;
	end

	local function findCurrentDirectoryToPrint()
		local currentDirectoryToPrint = currentDirectory;
		if (string.len(currentDirectoryToPrint) > this:GetWidth() - 4) then
			local toCut = string.len(currentDirectoryToPrint) - this:GetWidth() + 12;
			currentDirectoryToPrint = '...'..string.sub(currentDirectoryToPrint, toCut, string.len(currentDirectoryToPrint));
		end

		return currentDirectoryToPrint;
	end

	local function writeCurrentDirectory(videoBuffer)
		local colorConfiguration = System:GetColorConfiguration();
		videoBuffer:SetColorParameters(colors.red, colorConfiguration:GetColor('WindowColor'));

		local currentDirectoryToPrint = findCurrentDirectoryToPrint();

		videoBuffer:WriteAt(1, this:GetHeight() - 3, currentDirectoryToPrint);
	end

	local function drawGrid(videoBuffer)
		videoBuffer:DrawBlock(0, 2, this:GetWidth() - 2, this:GetHeight() - 5, colors.white);
	end

	local function drawFiles(videoBuffer)
		local files = getFiles();
		
		videoBuffer:SetBackgroundColor(colors.white);
		
		local lastLine = #files;
		if (lastLine > this:GetHeight() - 5 + vScrollBar:GetValue()) then
			lastLine = this:GetHeight() - 5 + vScrollBar:GetValue();
		end
		for i = vScrollBar:GetValue() + 1, lastLine do
			videoBuffer:SetCursorPos(1, i + 1 - vScrollBar:GetValue());
			if (fs.isDir(currentDirectory..'/'..files[i]) or files[i] == '..') then
				videoBuffer:SetTextColor(colors.blue);
			else
				videoBuffer:SetTextColor(colors.green);
			end
			if (selectedFile == files[i]) then
				videoBuffer:SetBackgroundColor(colors.lightBlue);
			else
				videoBuffer:SetBackgroundColor(colors.white);
			end
			videoBuffer:Write(files[i]);
		end
	end

	function this.Draw(_, videoBuffer)
		drawGrid(videoBuffer);
		drawFiles(videoBuffer);

		writeCurrentDirectory(videoBuffer);
	end

	function this.Update()
		local files = getFiles();
		if (#files > 1) then
			vScrollBar:SetMaxValue(#files - 1);
		else
			vScrollBar:SetMaxValue(1);
		end
	end

	local function back()
		selectedFile = '';
		vScrollBar:SetValue(0);
		if (currentDirectory ~= '/') then
			local i = string.len(currentDirectory);
			local endPos = 0;
			while (i >= 1 and endPos == 0) do
				if (string.sub(currentDirectory, i, i) == '/') then
					endPos = i;
				end
				i = i - 1;
			end
			currentDirectory = ''..string.sub(currentDirectory, 1, endPos - 1);
		end
	end

	local function processFileSelection(cursorX, cursorY)
		if (cursorX < this:GetX() + this:GetWidth() - 3) then
			local files = getFiles();
			local clickedLine = cursorY - 1 - this:GetY() + vScrollBar:GetValue();
			if (files[clickedLine] ~= nil) then
				if (files[clickedLine] == '..') then
					selectedFile = '';
				else
					selectedFile = files[clickedLine];
				end
			else
				selectedFile = '';
			end
		end
	end

	function this.ProcessLeftClickEvent(_, cursorX, cursorY)
		processFileSelection(cursorX, cursorY);
	end

	function this.ProcessRightClickEvent(_, cursorX, cursorY)
		this:CloseAllMenues();
		processFileSelection(cursorX, cursorY);
		if (selectedFile ~= '') then
			contextMenu.X = cursorX;
			contextMenu.Y = cursorY;
			this:OpenMenu('ContextMenu');
		end
		return this:Contains(cursorX, cursorY);
	end

	function this.ProcessDoubleClickEvent(_, cursorX, cursorY)
		if (cursorX < this:GetX() + this:GetWidth() - 3) then
			local files = getFiles();

			local clickedLine = cursorY - 1 - this:GetY() + vScrollBar:GetValue();
			if (files[clickedLine] ~= nil) then
				local clickedFile = currentDirectory..'/'..files[clickedLine];
				if (files[clickedLine] == '..') then
					back();
				elseif (fs.isDir(clickedFile)) then
					currentDirectory = clickedFile;
					vScrollBar:SetValue(0);
					selectedFile = '';
				end
			end
		end
	end

	local function createDirectory(_directoryName)
		local newDirectoryName = currentDirectory..'/'.._directoryName;
		if (fs.exists(newDirectoryName)) then
			local errorWindow = MessageWindow(this:GetApplication(), 'Directory exists', '   Directory with such name          allready exists.');
			errorWindow:Show();
		else
			fs.makeDir(newDirectoryName);
		end
	end

	local function createFile(_fileName)
		local newFileName = currentDirectory..'/'.._fileName;
		if (fs.exists(newFileName)) then
			local errorWindow = MessageWindow(this:GetApplication(), 'File exists', 'File or directory with such     name allready exists.');
			errorWindow:Show();
		else
			local descryptor = fs.open(newFileName, 'w');
			descryptor.close();
		end
	end

	local function renameFile(_newFileName)
		local newFileName = currentDirectory..'/'.._newFileName;
		local oldFileName = currentDirectory..'/'..selectedFile;
		if (fs.exists(newFileName)) then
			local errorWindow = MessageWindow(this:GetApplication(), 'File exists', 'File or directory with such     name allready exists.');
			errorWindow:Show();
		else
			fs.copy(oldFileName, newFileName);
			fs.delete(oldFileName);
		end
	end

	local function resetCopyCut()
		cuttedFile = '';
		copiedFile = '';
	end

	local function copyFile(fileName, accessPath)
		if (fs.isDir(fileName)) then
			local newPathParts = stringExtAPI.separate(accessPath, '/');
			local oldPathParts = stringExtAPI.separate(fileName, '/');
			local name = fs.getName(fileName);
			local equal = true;
			for i = 1, #oldPathParts do
				if (oldPathParts[i] ~= newPathParts[i]) then
					equal = false;
				end
			end
			if (equal) then
				return false;
			end
		end
		fs.copy(fileName, accessPath);
		return true;
	end

	local function paste()
		local fileName = '';
		if (copiedFile ~= '') then
			fileName = copiedFile;
		end
		if (cuttedFile ~= '') then
			fileName = cuttedFile;
		end
		local name = fs.getName(fileName);
		if (fileName ~= '') then
			local accessPath = currentDirectory..'/'..name;
			if (fs.exists(accessPath)) then
				local errorWindow = MessageWindow(this:GetApplication(), 'File exists', 'File "'..name..'" allready exists in current directory.');
				errorWindow:Show();
				resetCopyCut();
				return;
			end
			if (not copyFile(fileName, accessPath)) then
				local errorWindow = MessageWindow(this:GetApplication(), 'Wrong operation', "Can't copy directory inside itself.");
				errorWindow:Show();
				resetCopyCut();
			end
		end
		if (cuttedFile ~= '') then
			fs.delete(cuttedFile);
		end
		resetCopyCut();
	end

	local function pasteButtonClick(sender, eventArgs)
		paste();
	end

	local function newDirectoryDialogOk(sender, eventArgs)
		local directoryName = eventArgs.Text;
		createDirectory(directoryName);
	end

	local function createDirectoryButtonClick(sender, eventArgs)
		local newDirectoryDialog = EnterTextDialog(this:GetApplication(), 'Create directory', 'Enter new directory name:');
		newDirectoryDialog:SetOnOk(EventHandler(newDirectoryDialogOk));
		newDirectoryDialog:Show();
	end

	local function newFileDialogOk(sender, eventArgs)
		local fileName = eventArgs.Text;
		createFile(fileName);
	end

	local function createFileButtonClick(sender, eventArgs)
		local newFileDialog = EnterTextDialog(this:GetApplication(), 'Create file', 'Enter new file name:');
		newFileDialog:SetOnOk(EventHandler(newFileDialogOk));
		newFileDialog:Show();
	end

	local function copyButtonClick(sender, eventArgs)
		copiedFile = currentDirectory..'/'..selectedFile;
		cuttedFile = '';
	end

	local function cutButtonClick(sender, eventArgs)
		cuttedFile =  currentDirectory..'/'..selectedFile;
		copiedFile = '';
	end

	local function deleteDialogYes(sender, eventArgs)
		if (selectedFile ~= '' and selectedFile ~= nil) then
			fs.delete(currentDirectory..'/'..selectedFile);
		end
	end

	local function deleteButtonClick(sender, eventArgs)
		if (selectedFile ~= '' and selectedFile ~= nil) then
			local deleteDialog = QuestionDialog(this:GetApplication(), 'Delete?', 'Do you really want to delete     "'..selectedFile..'"?');
			deleteDialog:SetOnYes(EventHandler(deleteDialogYes));
			deleteDialog:Show();
		end
	end

	local function renameDialogOk(sender, eventArgs)
		local newFileName = eventArgs.Text;
		renameFile(newFileName);
	end

	local function renameButtonClick(sender, eventArgs)
		local renameDialog = EnterTextDialog(this:GetApplication(), 'Rename', 'Enter new name:', selectedFile);
		renameDialog:SetOnOk(EventHandler(renameDialogOk));
		renameDialog:Show();
	end

	function this.ProcessKeyEvent(_, key)
		if (keys.getName(key) == 'delete') then
			deleteButtonClick(nil, nil);
		end
	end

	local function onWindowResize(_sender, _eventArgs)
		vScrollBar.Height = this:GetHeight() - 5;
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		vScrollBar = VerticalScrollBar(0, 10, 7, nil, nil, -1, 1, 'right-top');
		this:AddComponent(vScrollBar);

		pasteButton = Button('Paste', nil, nil, 0, -1, 'left-bottom');
		pasteButton:SetOnClick(EventHandler(pasteButtonClick));
		this:AddComponent(pasteButton);

		createDirectoryButton = Button('Create directory', nil, nil, 6, -1, 'left-bottom');
		createDirectoryButton:SetOnClick(EventHandler(createDirectoryButtonClick));
		this:AddComponent(createDirectoryButton);

		createFileButton = Button('Create file', nil, nil, 23, -1, 'left-bottom');
		createFileButton:SetOnClick(EventHandler(createFileButtonClick));
		this:AddComponent(createFileButton);

		contextMenu = PopupMenu(1, 1, 10, 9, nil, true);
		this:AddMenu('ContextMenu', contextMenu);

		copyButton = Button('Copy', nil, nil, 1, 1, 'left-top');
		copyButton:SetOnClick(EventHandler(copyButtonClick));
		contextMenu:AddComponent(copyButton);

		cutButton = Button('Cut', nil, nil, 1, 3, 'left-top');
		cutButton:SetOnClick(EventHandler(cutButtonClick));
		contextMenu:AddComponent(cutButton);

		deleteButton = Button('Delete', nil, nil, 1, 5, 'left-top');
		deleteButton:SetOnClick(EventHandler(deleteButtonClick));
		contextMenu:AddComponent(deleteButton);

		renameButton = Button('Rename', nil, nil, 1, 7, 'left-top');
		renameButton:SetOnClick(EventHandler(renameButtonClick));
		contextMenu:AddComponent(renameButton);

		this:SetOnResize(EventHandler(onWindowResize));
	end

	local function constructor(_application)
		currentDirectory = '/';
		selectedFile = '';
		copiedFile = '';
		cuttedFile = '';

		initializeComponents();
	end

	constructor(_application);
end)
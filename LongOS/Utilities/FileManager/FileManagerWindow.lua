local Window = Classes.Application.Window;

local Button = Classes.Components.Button;
local VerticalScrollBar = Classes.Components.VerticalScrollBar; 
local PopupMenu = Classes.Components.PopupMenu;

local MessageWindow = Classes.System.Windows.MessageWindow;
local EnterTextDialog = Classes.System.Windows.EnterTextDialog;
local QuestionDialog = Classes.System.Windows.QuestionDialog;


FileManagerWindow = Class(Window, function(this, _application)

	Window.init(this, _application, 'Gvin file manager', false);
	this:SetTitle('Gvin file manager');
	this:SetX(5);
	this:SetY(3);
	this:SetWidth(40);
	this:SetHeight(12);
	this:SetMinimalWidth(36);
	this:SetMinimalHeight(8);

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
	local createFileButton;
	local contextMenu;

	local EXECUTABLE_FILE_EXTENSION = '.exec';
	local IMAGE_FILE_EXTENSION = '.image';

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function getFiles()
		local files =  fs.list(currentDirectory);
		table.insert(files, '..');
		table.sort(files);
		return files;
	end

	local function isExecutable(fileName)
		return stringExtAPI.endsWith(fileName, EXECUTABLE_FILE_EXTENSION);
	end

	local function isImage(fileName)
		return stringExtAPI.endsWith(fileName, IMAGE_FILE_EXTENSION);
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

			local currentFile = currentDirectory..'/'..files[i];
			if (fs.isDir(currentFile) or files[i] == '..') then
				videoBuffer:SetTextColor(colors.blue);
			elseif (isExecutable(currentFile)) then
				videoBuffer:SetTextColor(colors.orange);
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
				elseif (isExecutable(clickedFile)) then
					System:RunFile(clickedFile);
				elseif (isImage(clickedFile)) then
					System:RunFile('/LongOS/Utilities/BiriPaint/BiriPaint.exec '..clickedFile);
				end
			end
		end
	end

	local function createDirectory(_directoryName)
		local newDirectoryName = currentDirectory..'/'.._directoryName;
		newDirectoryName = string.sub(newDirectoryName, 2, newDirectoryName:len());
		if (fs.exists(newDirectoryName)) then
			local errorWindow = MessageWindow(this:GetApplication(), 'Directory exists', '   Directory with such name          allready exists.');
			errorWindow:ShowModal();
		else
			local ok = pcall(fs.makeDir, newDirectoryName);
			if (not ok) then
				local errorWindow = MessageWindow(this:GetApplication(), 'Unable to create', '  Unable to create directory  "'..newDirectoryName..'".');
				errorWindow:ShowModal();
			end
		end
	end

	local function createFile(_fileName)
		local newFileName = currentDirectory..'/'.._fileName;
		newFileName = string.sub(newFileName, 2, newFileName:len());
		if (fs.exists(newFileName)) then
			local errorWindow = MessageWindow(this:GetApplication(), 'File exists', 'File or directory with such     name allready exists.');
			errorWindow:ShowModal();
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
			errorWindow:ShowModal();
		elseif (fs.isReadOnly(oldFileName)) then
			local errorWindow = MessageWindow(this:GetApplication(), 'File is read-only', 'Selected file is read-only, it cannot be renamed or deleted.');
			errorWindow:ShowModal();
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
				errorWindow:ShowModal();
				resetCopyCut();
				return;
			end
			if (cuttedFile ~= '' and fs.isReadOnly(cuttedFile)) then
				local errorWindow = MessageWindow(this:GetApplication(), 'File is read-only', 'Selected file is read-only, it cannot be renamed or deleted.');
				errorWindow:ShowModal();
				resetCopyCut();
				return;
			end
			if (not copyFile(fileName, accessPath)) then
				local errorWindow = MessageWindow(this:GetApplication(), 'Wrong operation', "Can't copy directory inside itself.");
				errorWindow:ShowModal();
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
		newDirectoryDialog:AddOnOkEventHandler(newDirectoryDialogOk);
		newDirectoryDialog:ShowModal();
	end

	local function newFileDialogOk(sender, eventArgs)
		local fileName = eventArgs.Text;
		createFile(fileName);
	end

	local function createFileButtonClick(sender, eventArgs)
		local newFileDialog = EnterTextDialog(this:GetApplication(), 'Create file', 'Enter new file name:');
		newFileDialog:AddOnOkEventHandler(newFileDialogOk);
		newFileDialog:ShowModal();
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
			if (fs.isReadOnly(currentDirectory..'/'..selectedFile)) then
				local errorWindow = MessageWindow(this:GetApplication(), 'File is read-only', 'Selected file is read-only, it cannot be renamed or deleted.');
				errorWindow:ShowModal();
			else
				fs.delete(currentDirectory..'/'..selectedFile);
			end
		end
	end

	local function deleteButtonClick(sender, eventArgs)
		if (selectedFile ~= '' and selectedFile ~= nil) then
			local deleteDialog = QuestionDialog(this:GetApplication(), 'Delete?', 'Do you really want to delete     "'..selectedFile..'"?');
			deleteDialog:AddOnYesEventHandler(deleteDialogYes);
			deleteDialog:ShowModal();
		end
	end

	local function renameDialogOk(sender, eventArgs)
		local newFileName = eventArgs.Text;
		renameFile(newFileName);
	end

	local function renameButtonClick(sender, eventArgs)
		local renameDialog = EnterTextDialog(this:GetApplication(), 'Rename', 'Enter new name:', selectedFile);
		renameDialog:AddOnOkEventHandler(renameDialogOk);
		renameDialog:ShowModal();
	end

	function this.ProcessKeyEvent(_, key)
		if (keys.getName(key) == 'delete') then
			deleteButtonClick(nil, nil);
		end
	end

	function this.ProcessMouseScrollEvent(_, _direction, _cursorX, _cursorY)
		if (_direction < 0) then
			vScrollBar:ScrollUp();
		else
			vScrollBar:ScrollDown();
		end
	end

	local function onWindowResize(_sender, _eventArgs)
		vScrollBar:SetHeight(this:GetHeight() - 5);
	end

	local function runInTerminalButtonClick(_sender, _eventArgs)
		local fullPath = currentDirectory..'/'..selectedFile;
		fullPath = string.sub(fullPath, 2, fullPath:len());
		if (selectedFile ~= '' and selectedFile ~= '..' and not fs.isDir(fullPath) and not isExecutable(fullPath) and not isImage(fullPath)) then
			System:RunFile('/LongOS/SystemUtilities/Terminal/GvinTerminal.exec '..fullPath);
		else
			local errorMessage = MessageWindow(this:GetApplication(), "Can't launch", 'Unable to lauch selected file.');
			errorMessage:ShowModal();
		end
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		vScrollBar = VerticalScrollBar(0, 10, 7, nil, nil, 0, 1, 'right-top');
		this:AddComponent(vScrollBar);

		pasteButton = Button('Paste', nil, nil, 0, 0, 'left-bottom');
		pasteButton:AddOnClickEventHandler(pasteButtonClick);
		this:AddComponent(pasteButton);

		createDirectoryButton = Button('Create directory', nil, nil, 6, 0, 'left-bottom');
		createDirectoryButton:AddOnClickEventHandler(createDirectoryButtonClick);
		this:AddComponent(createDirectoryButton);

		createFileButton = Button('Create file', nil, nil, 23, 0, 'left-bottom');
		createFileButton:AddOnClickEventHandler(createFileButtonClick);
		this:AddComponent(createFileButton);

		contextMenu = PopupMenu(1, 1, 10, 11, nil, false);
		this:AddMenu('ContextMenu', contextMenu);

		local runInTerminalButton = Button('Run in terminal', nil, nil, 1, 1, 'left-top');
		runInTerminalButton:AddOnClickEventHandler(runInTerminalButtonClick);
		contextMenu:AddComponent(runInTerminalButton);

		local copyButton = Button('Copy', nil, nil, 6, 3, 'left-top');
		copyButton:AddOnClickEventHandler(copyButtonClick);
		contextMenu:AddComponent(copyButton);

		local cutButton = Button('Cut ', nil, nil, 6, 5, 'left-top');
		cutButton:AddOnClickEventHandler(cutButtonClick);
		contextMenu:AddComponent(cutButton);

		local deleteButton = Button('Delete', nil, nil, 5, 7, 'left-top');
		deleteButton:AddOnClickEventHandler(deleteButtonClick);
		contextMenu:AddComponent(deleteButton);

		local renameButton = Button('Rename', nil, nil, 5, 9, 'left-top');
		renameButton:AddOnClickEventHandler(renameButtonClick);
		contextMenu:AddComponent(renameButton);

		this:AddOnResizeEventHandler(onWindowResize);
	end

	local function constructor()
		currentDirectory = '/';
		selectedFile = '';
		copiedFile = '';
		cuttedFile = '';

		initializeComponents();
	end

	constructor();
end)
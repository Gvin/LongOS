local Window = Classes.Application.Window;

local Button = Classes.Components.Button;
local FileBrowser = Classes.Components.FileBrowser;
local PopupMenu = Classes.Components.PopupMenu;

local MessageWindow = Classes.System.Windows.MessageWindow;
local EnterTextDialog = Classes.System.Windows.EnterTextDialog;
local QuestionDialog = Classes.System.Windows.QuestionDialog;

FileManagerWindow = Class(Window, function(this, _application)

	Window.init(this, _application, 'Gvin file manager', false);
	this:SetTitle('Gvin file manager');
	this:SetWidth(40);
	this:SetHeight(12);
	this:SetMinimalWidth(36);
	this:SetMinimalHeight(8);

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local fileBrowser;
	local pasteButton;
	local createDirectoryButton;
	local createFileButton;

	local contextMenu;

	local editButton;

	local copiedFile;
	local cuttedFile;

	local fileAssotiationConfiguration;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function fileBrowserOnFileLaunch(_sender, _eventArgs)
		local filePath = _eventArgs[1];
		local assotiation = fileAssotiationConfiguration:GetAssotiation(stringExtAPI.getExtension(filePath));
		if (assotiation ~= nil) then
			if (assotiation.Application == '') then
				System:RunFile(filePath);
			else
				System:RunFile(assotiation.Application..' '..filePath);
			end
		end
	end

	local function fileBrowserOnFileRightClick(_sender, _eventArgs)
		local screenWidth, screenHeight = term.getSize();

		if (fs.isDir(_eventArgs.FilePath)) then
			editButton:SetVisible(false);
			contextMenu.Height = 11;
		else
			editButton:SetVisible(true);
			contextMenu.Height = 13;
		end

		this:CloseAllMenues();
		contextMenu.X = _eventArgs.X;
		contextMenu.Y = _eventArgs.Y;

		if (contextMenu.Y + contextMenu.Height > screenHeight) then
			contextMenu.Y = screenHeight - contextMenu.Height + 1;
		end

		this:OpenMenu('ContextMenu');
	end

	local function windowOnResize(_sender, _eventArgs)
		fileBrowser:SetWidth(this:GetWidth() - 2);
		fileBrowser:SetHeight(this:GetHeight() - 3);
	end

	local function runInTerminalButtonClick(_sender, _eventArgs)
		local fullPath = fileBrowser:GetCurrentDirectory()..'/'..fileBrowser:GetSelectedFile();
		fullPath = string.sub(fullPath, 2, fullPath:len());
		if (fileBrowser:GetSelectedFile() ~= '' and not fs.isDir(fullPath)) then
			System:RunFile('%SYSDIR%/SystemUtilities/Terminal/GvinTerminal.exec '..fullPath);
		else
			local errorMessage = MessageWindow(this:GetApplication(), "Can't launch", 'Unable to lauch selected file.');
			errorMessage:ShowModal();
		end
	end

	local function deleteDialogYes(_sender, _eventArgs)
		if (fileBrowser:GetSelectedFile() ~= '' and fileBrowser:GetSelectedFile() ~= nil) then
			local filePath = fs.combine(fileBrowser:GetCurrentDirectory(), fileBrowser:GetSelectedFile());
			if (fs.isReadOnly(filePath)) then
				local errorWindow = MessageWindow(this:GetApplication(), 'File is read-only', 'Selected file is read-only, it cannot be renamed or deleted.');
				errorWindow:ShowModal();
			else
				fs.delete(filePath);
			end
		end
	end

	local function deleteButtonClick(_sender, _eventArgs)
		if (fileBrowser:GetSelectedFile() ~= '' and fileBrowser:GetSelectedFile() ~= nil) then
			local deleteDialog = QuestionDialog(this:GetApplication(), 'Delete?', 'Do you really want to delete     "'..fileBrowser:GetSelectedFile()..'"?');
			deleteDialog:AddOnYesEventHandler(deleteDialogYes);
			deleteDialog:ShowModal();
		end
	end

	local function createFile(_fileName)
		local newFileName = fs.combine(fileBrowser:GetCurrentDirectory(), _fileName);
		if (fs.exists(newFileName)) then
			local errorWindow = MessageWindow(this:GetApplication(), 'File exists', 'File or directory with such     name allready exists.');
			errorWindow:ShowModal();
		else
			local descryptor = fs.open(newFileName, 'w');
			descryptor.close();
		end
	end

	local function newFileDialogOk(_sender, _eventArgs)
		local fileName = _eventArgs.Text;
		createFile(fileName);
	end

	local function createFileButtonClick(_sender, _eventArgs)
		local newFileDialog = EnterTextDialog(this:GetApplication(), 'Create file', 'Enter new file name:');
		newFileDialog:AddOnOkEventHandler(newFileDialogOk);
		newFileDialog:ShowModal();
	end

	local function createDirectory(_directoryName)
		local newDirectoryName = fs.combine(fileBrowser:GetCurrentDirectory(), _directoryName);
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

	local function newDirectoryDialogOk(_sender, _eventArgs)
		local directoryName = _eventArgs.Text;
		createDirectory(directoryName);
	end

	local function createDirectoryButtonClick(_sender, _eventArgs)
		local newDirectoryDialog = EnterTextDialog(this:GetApplication(), 'Create directory', 'Enter new directory name:');
		newDirectoryDialog:AddOnOkEventHandler(newDirectoryDialogOk);
		newDirectoryDialog:ShowModal();
	end

	local function editButtonClick(_sender, _eventArgs)
		local fullPath = fs.combine(fileBrowser:GetCurrentDirectory(), fileBrowser:GetSelectedFile());
		if (not fs.isDir(fullPath)) then
			System:RunFile('%SYSDIR%/SystemUtilities/Terminal/GvinTerminal.exec edit '..fullPath);
		end
	end

	local function copyButtonClick(sender, eventArgs)
		copiedFile = fs.combine(fileBrowser:GetCurrentDirectory(), fileBrowser:GetSelectedFile());
		cuttedFile = '';
	end

	local function cutButtonClick(sender, eventArgs)
		cuttedFile =  fs.combine(fileBrowser:GetCurrentDirectory(), fileBrowser:GetSelectedFile());
		copiedFile = '';
	end

	local function resetCopyCut()
		cuttedFile = '';
		copiedFile = '';
	end

	local function copyFile(_fileName, _accessPath)
		if (fs.isDir(_fileName)) then
			local newPathParts = stringExtAPI.separate(_accessPath, '/');
			local oldPathParts = stringExtAPI.separate(_fileName, '/');
			local name = fs.getName(_fileName);
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
		fs.copy(_fileName, _accessPath);
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
			local accessPath = fs.combine(fileBrowser:GetCurrentDirectory(), name);
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

	local function pasteButtonClick(_sender, _eventArgs)
		paste();
	end

	local function renameFile(_newFileName)
		local newFileName = fs.combine(fileBrowser:GetCurrentDirectory(), _newFileName);
		local oldFileName = fs.combine(fileBrowser:GetCurrentDirectory(), fileBrowser:GetSelectedFile());
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

	local function renameDialogOk(_sender, _eventArgs)
		local newFileName = _eventArgs.Text;
		renameFile(newFileName);
	end

	local function renameButtonClick(_sender, _eventArgs)
		local renameDialog = EnterTextDialog(this:GetApplication(), 'Rename', 'Enter new name:', fileBrowser:GetSelectedFile());
		renameDialog:AddOnOkEventHandler(renameDialogOk);
		renameDialog:ShowModal();
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		fileBrowser = FileBrowser(this:GetWidth() - 2, this:GetHeight() - 3, 0, 0, 'left-top');
		fileBrowser:AddOnFileLaunchEventHandler(fileBrowserOnFileLaunch);
		fileBrowser:AddOnFileRightClickEventHandler(fileBrowserOnFileRightClick);
		this:AddComponent(fileBrowser);

		pasteButton = Button('Paste', nil, nil, 0, 0, 'left-bottom');
		pasteButton:AddOnClickEventHandler(pasteButtonClick);
		this:AddComponent(pasteButton);

		createDirectoryButton = Button('Create directory', nil, nil, 6, 0, 'left-bottom');
		createDirectoryButton:AddOnClickEventHandler(createDirectoryButtonClick);
		this:AddComponent(createDirectoryButton);

		createFileButton = Button('Create file', nil, nil, 23, 0, 'left-bottom');
		createFileButton:AddOnClickEventHandler(createFileButtonClick);
		this:AddComponent(createFileButton);

		contextMenu = PopupMenu(1, 1, 12, 11, nil, false);
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

		editButton = Button('Edit', nil, nil, 6, 11, 'left-top');
		editButton:AddOnClickEventHandler(editButtonClick);
		contextMenu:AddComponent(editButton);

		this:AddOnResizeEventHandler(windowOnResize);
	end

	local function constructor()
		copiedFile = '';
		cuttedFile = '';
		fileAssotiationConfiguration = System:GetFileAssotiationsConfiguration();

		initializeComponents();
	end

	constructor();
end)
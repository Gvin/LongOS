local Window = Classes.Application.Window;

local Button = Classes.Components.Button;
local FileBrowser = Classes.Components.FileBrowser;
local PopupMenu = Classes.Components.PopupMenu;

local MessageWindow = Classes.System.Windows.MessageWindow;
local EnterTextDialog = Classes.System.Windows.EnterTextDialog;
local QuestionDialog = Classes.System.Windows.QuestionDialog;

local LocalizationManager = Classes.System.Localization.LocalizationManager;

FileManagerWindow = Class(Window, function(this, _application)

	Window.init(this, _application, 'Gvin file manager', false);
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
	local runInTerminalButton;

	local copiedFile;
	local cuttedFile;

	local fileAssotiationConfiguration;
	local localizationManager;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function showExistsMessage(_path)
		local errorWindow = MessageWindow(this:GetApplication(), localizationManager:GetLocalizedString('Errors.Exists.Title'), stringExtAPI.format(localizationManager:GetLocalizedString('Errors.Exists.Text'), _path));
		errorWindow:ShowModal();
	end

	local function showReadOnlyMessage()
		local errorWindow = MessageWindow(this:GetApplication(), localizationManager:GetLocalizedString('Errors.FileReadOnly.Title'), localizationManager:GetLocalizedString('Errors.FileReadOnly.Text'));
		errorWindow:ShowModal();
	end

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

		if (_eventArgs.IsDir) then
			editButton:SetVisible(false);
			runInTerminalButton:SetVisible(false);
			contextMenu.Height = 9;
		else
			editButton:SetVisible(true);
			runInTerminalButton:SetVisible(true);
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
		local fullPath = fs.combine(fileBrowser:GetCurrentDirectory(), fileBrowser:GetSelectedFile());
		if (fileBrowser:GetSelectedFile() ~= '' and not fs.isDir(fullPath)) then
			System:RunFile('%SYSDIR%/SystemUtilities/Terminal/GvinTerminal.exec '..fullPath);
		else
			local errorMessage = MessageWindow(this:GetApplication(), localizationManager:GetLocalizedString('Errors.UnableToLaunch.Title'), localizationManager:GetLocalizedString('Errors.UnableToLaunch.Text'));
			errorMessage:ShowModal();
		end
	end

	local function deleteDialogYes(_sender, _eventArgs)
		if (fileBrowser:GetSelectedFile() ~= '' and fileBrowser:GetSelectedFile() ~= nil) then
			local filePath = fs.combine(fileBrowser:GetCurrentDirectory(), fileBrowser:GetSelectedFile());
			if (fs.isReadOnly(filePath)) then
				showReadOnlyMessage();
			else
				fs.delete(filePath);
			end
		end
	end

	local function deleteButtonClick(_sender, _eventArgs)
		if (fileBrowser:GetSelectedFile() ~= '' and fileBrowser:GetSelectedFile() ~= nil) then
			local deleteDialog = QuestionDialog(this:GetApplication(), localizationManager:GetLocalizedString('Dialogs.Delete.Title'), stringExtAPI.format(localizationManager:GetLocalizedString('Dialogs.Delete.Text'), fileBrowser:GetSelectedFile()));
			deleteDialog:AddOnYesEventHandler(deleteDialogYes);
			deleteDialog:ShowModal();
		end
	end

	local function createFile(_fileName)
		local newFileName = fs.combine(fileBrowser:GetCurrentDirectory(), _fileName);
		if (fs.exists(newFileName)) then
			showExistsMessage(newFileName);
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
		local newFileDialog = EnterTextDialog(this:GetApplication(), localizationManager:GetLocalizedString('Dialogs.CreateFile.Title'), localizationManager:GetLocalizedString('Dialogs.CreateFile.Text'));
		newFileDialog:AddOnOkEventHandler(newFileDialogOk);
		newFileDialog:ShowModal();
	end

	local function createDirectory(_directoryName)
		local newDirectoryName = fs.combine(fileBrowser:GetCurrentDirectory(), _directoryName);
		if (fs.exists(newDirectoryName)) then
			showExistsMessage(newDirectoryName);
		else
			local ok = pcall(fs.makeDir, newDirectoryName);
			if (not ok) then
				local errorWindow = MessageWindow(this:GetApplication(), localizationManager:GetLocalizedString('Errors.UnableToCreate.Title'), stringExtAPI.format(localizationManager:GetLocalizedString('Errors.UnableToCreate.Text'), newDirectoryName));
				errorWindow:ShowModal();
			end
		end
	end

	local function newDirectoryDialogOk(_sender, _eventArgs)
		local directoryName = _eventArgs.Text;
		createDirectory(directoryName);
	end

	local function createDirectoryButtonClick(_sender, _eventArgs)
		local newDirectoryDialog = EnterTextDialog(this:GetApplication(), localizationManager:GetLocalizedString('Dialogs.CreateDirectory.Title'), localizationManager:GetLocalizedString('Dialogs.CreateDirectory.Text'));
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
				showExistsMessage(accessPath);
				resetCopyCut();
				return;
			end
			if (cuttedFile ~= '' and fs.isReadOnly(cuttedFile)) then
				showReadOnlyMessage();
				resetCopyCut();
				return;
			end
			if (not copyFile(fileName, accessPath)) then
				local errorWindow = MessageWindow(this:GetApplication(), localizationManager:GetLocalizedString('Errors.WrongOperation.Title'), localizationManager:GetLocalizedString('Errors.WrongOperation.Text'));
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
			showExistsMessage(newFileName);
		elseif (fs.isReadOnly(oldFileName)) then
			showReadOnlyMessage();
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
		local renameDialog = EnterTextDialog(this:GetApplication(), localizationManager:GetLocalizedString('Dialogs.Rename.Title'), localizationManager:GetLocalizedString('Dialogs.Rename.Text'), fileBrowser:GetSelectedFile());
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

		pasteButton = Button(localizationManager:GetLocalizedString('Buttons.Paste'), nil, nil, 0, 0, 'left-bottom');
		pasteButton:AddOnClickEventHandler(pasteButtonClick);
		this:AddComponent(pasteButton);

		createDirectoryButton = Button(localizationManager:GetLocalizedString('Buttons.CreateDirectory'), nil, nil, pasteButton:GetWidth() + 1, 0, 'left-bottom');
		createDirectoryButton:AddOnClickEventHandler(createDirectoryButtonClick);
		this:AddComponent(createDirectoryButton);

		createFileButton = Button(localizationManager:GetLocalizedString('Buttons.CreateFile'), nil, nil, createDirectoryButton:GetWidth() + createDirectoryButton:GetdX() + 1, 0, 'left-bottom');
		createFileButton:AddOnClickEventHandler(createFileButtonClick);
		this:AddComponent(createFileButton);

		contextMenu = PopupMenu(1, 1, 12, 11, nil, false);
		this:AddMenu('ContextMenu', contextMenu);

		runInTerminalButton = Button(localizationManager:GetLocalizedString('Buttons.ContextMenu.RunInTerminal'), nil, nil, 1, 9, 'left-top');
		runInTerminalButton:AddOnClickEventHandler(runInTerminalButtonClick);
		contextMenu:AddComponent(runInTerminalButton);

		local copyButton = Button(localizationManager:GetLocalizedString('Buttons.ContextMenu.Copy'), nil, nil, 1, 1, 'left-top');
		copyButton:AddOnClickEventHandler(copyButtonClick);
		contextMenu:AddComponent(copyButton);

		local cutButton = Button(localizationManager:GetLocalizedString('Buttons.ContextMenu.Cut'), nil, nil, 1, 3, 'left-top');
		cutButton:AddOnClickEventHandler(cutButtonClick);
		contextMenu:AddComponent(cutButton);

		local deleteButton = Button(localizationManager:GetLocalizedString('Buttons.ContextMenu.Delete'), nil, nil, 1, 5, 'left-top');
		deleteButton:AddOnClickEventHandler(deleteButtonClick);
		contextMenu:AddComponent(deleteButton);

		local renameButton = Button(localizationManager:GetLocalizedString('Buttons.ContextMenu.Rename'), nil, nil, 1, 7, 'left-top');
		renameButton:AddOnClickEventHandler(renameButtonClick);
		contextMenu:AddComponent(renameButton);

		editButton = Button(localizationManager:GetLocalizedString('Buttons.ContextMenu.Edit'), nil, nil, 1, 11, 'left-top');
		editButton:AddOnClickEventHandler(editButtonClick);
		contextMenu:AddComponent(editButton);

		this:AddOnResizeEventHandler(windowOnResize);
	end

	local function constructor()
		localizationManager = LocalizationManager(fs.combine(this:GetApplication():GetWorkingDirectory(), 'Localizations'), fs.combine(this:GetApplication():GetWorkingDirectory(), 'Localizations/default.xml'));
		localizationManager:ReadLocalization(System:GetSystemLocale());

		this:SetTitle(localizationManager:GetLocalizedString('Title'));

		copiedFile = '';
		cuttedFile = '';
		fileAssotiationConfiguration = System:GetFileAssotiationsConfiguration();

		initializeComponents();
	end

	constructor();
end)
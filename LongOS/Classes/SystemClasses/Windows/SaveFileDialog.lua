local Window = Classes.Application.Window;

local EventHandler = Classes.System.EventHandler;

local Label = Classes.Components.Label;
local Edit = Classes.Components.Edit;
local FileBrowser = Classes.Components.FileBrowser;
local Button = Classes.Components.Button;

Classes.System.Windows.SaveFileDialog = Class(Window, function(this, _application, _initialDirectory, _autoExtension)
	Window.init(this, _application, 'Save file dialog', false);
	this:SetX(10);
	this:SetY(3);
	this:SetWidth(30);
	this:SetHeight(14);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local autoExtension;

	local fileBrowser;
	local fileNameLabel;
	local fileExtensionLabel;
	local fileNameEdit;
	local okButton;
	local cancelButton;

	local onOk;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:AddOnOkEventHandler(_value)
		onOk:AddHandler(_value);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function getNewFileName()
		if (fileNameEdit:GetText() ~= '') then
			if (autoExtension ~= nil) then
				return fileNameEdit:GetText()..'.'..autoExtension;
			end

			return fileNameEdit:GetText();
		end

		if (fileBrowser:GetSelectedFile() ~= '') then
			return fileBrowser:GetSelectedFile()
		end

		return nil;
	end

	local function fileSelected()
		local newFileName = getNewFileName();
		if (newFileName ~= nil) then
			local eventArgs = {};
			eventArgs.FileName = newFileName;
			eventArgs.FileDir = fileBrowser:GetCurrentDirectory();
			eventArgs.FullPath = eventArgs.FileDir..'/'..eventArgs.FileName;

			onOk:Invoke(this, eventArgs);
			this:Close();
		end
	end

	local function fileBrowserSelectionChanged(_sender, _eventArgs)
		if (fileBrowser:GetSelectedFile() ~= '') then
			local fileName = fileBrowser:GetCurrentDirectory()..'/'..fileBrowser:GetSelectedFile();
			if (not fs.isDir(fileName)) then
				local nameWithoutExtension = fileBrowser:GetSelectedFile();
				if (autoExtension ~= nil) then
					nameWithoutExtension = nameWithoutExtension:sub(1, nameWithoutExtension:len() - autoExtension:len() - 1);
				end
				fileNameEdit:SetText(nameWithoutExtension);
			end
		end
	end

	local function fileBrowserFileLaunch(_sender, _eventArgs)
		fileSelected();
	end

	local function okButtonClick(_sender, _eventArgs)
		fileSelected();
	end

	local function cancelButtonClick(_sender, _eventArgs)
		this:Close();
	end

	local function filesFilter(_currentDirectory, _fileName)
		return autoExtension == nil or stringExtAPI.getExtension(_fileName) == autoExtension;
	end

	function this:ProcessKeyEvent(_key)
		if (keys.getName(_key) == 'enter') then
			fileSelected();
		end
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------
	local function initializeComponents(_initialDirectory)
		if (type(_initialDirectory) ~= 'string') then
			error('OpenFileDialog.Constructor [initialDirectory]: String expected, got '..type(_initialDirectory)..'.');
		end

		fileBrowser = Classes.Components.FileBrowser(28, 8, 0, 0, 'left-top');
		fileBrowser:SetFilesFilter(filesFilter);
		fileBrowser:SetCurrentDirectory(_initialDirectory);
		fileBrowser:AddOnFileLaunchEventHandler(fileBrowserFileLaunch);
		fileBrowser:AddOnSelectionChangedEventHandler(fileBrowserSelectionChanged);
		this:AddComponent(fileBrowser);

		fileNameLabel = Label(System:GetLocalizedString('System.Windows.SaveFile.Labels.FileName'), nil, nil, 0, 3, 'left-bottom');
		this:AddComponent(fileNameLabel);

		local editWidth = 28;
		if (autoExtension ~= nil) then
			editWidth = editWidth - autoExtension:len() - 1;

			fileExtensionLabel = Label('.'..autoExtension, nil, nil, 0, 2, 'right-bottom');
			this:AddComponent(fileExtensionLabel);
		end

		fileNameEdit = Edit(editWidth, nil, nil, 0, 2, 'left-bottom');
		fileNameEdit:SetFocus(true);
		this:AddComponent(fileNameEdit);

		okButton = Button(System:GetLocalizedString('Action.Ok'), nil, nil, 0, 0, 'left-bottom');
		okButton:AddOnClickEventHandler(okButtonClick);
		this:AddComponent(okButton);

		cancelButton = Button(System:GetLocalizedString('Action.Cancel'), nil, nil, 0, 0, 'right-bottom');
		cancelButton:AddOnClickEventHandler(cancelButtonClick);
		this:AddComponent(cancelButton);
	end

	local function constructor(_initialDirectory, _autoExtension)
		if (_autoExtension ~= nil and type(_autoExtension) ~= 'string') then
			error('SaveFileDialog.Constructor [autoExtension]: String or nil expected, got '..type(_autoExtension)..'.');
		end

		this:SetTitle(System:GetLocalizedString('System.Windows.SaveFile.Title'));

		autoExtension = _autoExtension;

		onOk = EventHandler();

		initializeComponents(_initialDirectory);
	end

	constructor(_initialDirectory, _autoExtension);
end)
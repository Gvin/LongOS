local Window = Classes.Application.Window;
local EventHandler = Classes.System.EventHandler;

Classes.System.Windows.OpenFileDialog = Class(Window, function(this, _application, _initialDirectory, _allowedExtensions)
	Window.init(this, _application, 'Open file dialog', false);
	this:SetX(10);
	this:SetY(3);
	this:SetWidth(30);
	this:SetHeight(12);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local fileBrowser;
	local okButton;
	local cancelButton;

	local allowedExtensions;

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

	local function fileSelected()
		local eventArgs = {};
		eventArgs.FileName = fileBrowser:GetSelectedFile();
		eventArgs.FileDir = fileBrowser:GetCurrentDirectory();
		eventArgs.FullPath = eventArgs.FileDir..'/'..eventArgs.FileName;

		if (eventArgs.FileName ~= '' and not fs.isDir(eventArgs.FullPath)) then
			onOk:Invoke(this, eventArgs);
			this:Close();
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
		return allowedExtensions == nil or tableExtAPI.contains(allowedExtensions, stringExtAPI.getExtension(_fileName));
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
		this:AddComponent(fileBrowser);

		okButton = Classes.Components.Button(System:GetLocalizedString('Action.Ok'), nil, nil, 0, 0, 'left-bottom');
		okButton:AddOnClickEventHandler(okButtonClick);
		this:AddComponent(okButton);

		cancelButton = Classes.Components.Button(System:GetLocalizedString('Action.Cancel'), nil, nil, 0, 0, 'right-bottom');
		cancelButton:AddOnClickEventHandler(cancelButtonClick);
		this:AddComponent(cancelButton);
	end

	local function constructor(_initialDirectory, _allowedExtensions)
		if (_allowedExtensions ~= nil and type(_allowedExtensions) ~= 'table') then
			error('OpenFileDialog.Constructor [allowedExtensions]: Table expected, got '..type(_allowedExtensions)..'.');
		end

		this:SetTitle(System:GetLocalizedString('System.Windows.OpenFile.Title'));

		allowedExtensions = _allowedExtensions;

		onOk = EventHandler();

		initializeComponents(_initialDirectory);
	end

	constructor(_initialDirectory, _allowedExtensions);
end)
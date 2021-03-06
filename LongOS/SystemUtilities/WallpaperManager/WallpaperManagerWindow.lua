local Window = Classes.Application.Window;
local Button = Classes.Components.Button;
local Label = Classes.Components.Label;
local Edit = Classes.Components.Edit;
local OpenFileDialog = Classes.System.Windows.OpenFileDialog;
local MessageWindow = Classes.System.Windows.MessageWindow;

local LocalizationManager = Classes.System.Localization.LocalizationManager;

WallpaperManagerWindow = Class(Window, function(this, _application)
	Window.init(this, _application, 'Wallpaper manager', false);
	this:SetWidth(40);
	this:SetHeight(11);
	this:SetAllowResize(false);
	this:SetAllowMaximize(false);

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local interfaceConfiguration;

	local saveChangesButton;
	local cancelButton;
	local browseButton;
	local currentWallpaperLabel;
	local xEdit;
	local xLabel;
	local yEdit;
	local yLabel;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:Draw(_videoBuffer)
		local wallpaperPath = interfaceConfiguration:GetOption('WallpaperFileName');
		local toPrint = wallpaperPath;
		if (toPrint:len() > 32) then
			toPrint = '...'..toPrint:sub(toPrint:len() - 32, toPrint:len());
		end

		local colorConfiguration = System:GetColorConfiguration();
		_videoBuffer:SetTextColor(colorConfiguration:GetColor('SystemLabelsTextColor'));
		_videoBuffer:SetBackgroundColor(colorConfiguration:GetColor('WindowColor'));
		_videoBuffer:WriteAt(2, 3, toPrint);
	end

	local function saveChangesButtonClick(_sender, _eventArgs)
		interfaceConfiguration:SetOption('WallpaperXShift', xEdit:GetText());
		interfaceConfiguration:SetOption('WallpaperYShift', yEdit:GetText());
		interfaceConfiguration:WriteConfiguration();
		System:ReadConfiguration();
		this:Close();
	end

	local function cancelButtonClick(_sender, _eventArgs)
		this:Close();
	end

	local function fileNameDialogOnOk(_sender, _eventArgs)
		local fileName = _eventArgs.FullPath;
		if (fs.exists(fileName) and stringExtAPI.endsWith(fileName, '.image')) then
			interfaceConfiguration:SetOption('WallpaperFileName', fileName);
		else
			local errorMessage = MessageWindow(this:GetApplication(), 'Invalid path', 'Invalid file path.');
			errorMessage:ShowModal();
		end
	end

	local function browseButtonClick(_sender, _eventArgs)
		local wallpaperPath = interfaceConfiguration:GetOption('WallpaperFileName');
		local dir = System:ResolvePath(stringExtAPI.getPath(wallpaperPath));
		local fileNameDialog = OpenFileDialog(this:GetApplication(), dir, { 'image' });
		fileNameDialog:SetTitle(localizationManager:GetLocalizedString('BrowseForWallpaper'));
		fileNameDialog:AddOnOkEventHandler(fileNameDialogOnOk);
		fileNameDialog:ShowModal();
	end

	local function windowOnClose(_sender, _eventArgs)
		interfaceConfiguration:ReadConfiguration();
	end

	local function editTextFilter(_char)
		return (tonumber(_char) ~= nil);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		saveChangesButton = Button(System:GetLocalizedString('Action.SaveChanges'), nil, nil, 0, 0, 'left-bottom');
		saveChangesButton:AddOnClickEventHandler(saveChangesButtonClick);
		this:AddComponent(saveChangesButton);

		cancelButton = Button(System:GetLocalizedString('Action.Cancel'), nil, nil, 0, 0, 'right-bottom');
		cancelButton:AddOnClickEventHandler(cancelButtonClick);
		this:AddComponent(cancelButton);

		currentWallpaperLabel = Label(localizationManager:GetLocalizedString('Labels.CurrentWallpaper'), nil, nil, 0, 0, 'left-top');
		this:AddComponent(currentWallpaperLabel);

		browseButton = Button(System:GetLocalizedString('Action.Browse'), nil, nil, currentWallpaperLabel:GetText():len() + 2, 0, 'left-top');
		browseButton:AddOnClickEventHandler(browseButtonClick);
		this:AddComponent(browseButton);

		local shiftLabel = Label(localizationManager:GetLocalizedString('Labels.Shift'), nil, nil, 1, 4, 'left-top');
		this:AddComponent(shiftLabel);

		xLabel = Label('X:', nil, nil, 1, 6, 'left-top');
		this:AddComponent(xLabel);

		xEdit = Edit(4, nil, nil, 3, 6, 'left-top');	
		xEdit:SetText(interfaceConfiguration:GetOption('WallpaperXShift'));	
		xEdit:SetFilter(editTextFilter);
		this:AddComponent(xEdit);

		yLabel = Label('Y:', nil, nil, 8, 6, 'left-top');
		this:AddComponent(yLabel);

		yEdit = Edit(4, nil, nil, 10, 6, 'left-top');
		yEdit:SetText(interfaceConfiguration:GetOption('WallpaperYShift'));
		yEdit:SetFilter(editTextFilter);
		this:AddComponent(yEdit);


	end

	local function constructor()
		interfaceConfiguration = System:GetInterfaceConfiguration();
		this:AddOnCloseEventHandler(windowOnClose);

		localizationManager = LocalizationManager(fs.combine(this:GetApplication():GetWorkingDirectory(), 'Localizations'), fs.combine(this:GetApplication():GetWorkingDirectory(), 'Localizations/default.xml'));
		localizationManager:ReadLocalization(System:GetSystemLocale());

		this:SetTitle(localizationManager:GetLocalizedString('Title'));

		initializeComponents();
	end

	constructor();
end)
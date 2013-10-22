local Window = Classes.Application.Window;
local Button = Classes.Components.Button;
local Label = Classes.Components.Label;

local LocalizationManager = Classes.System.Localization.LocalizationManager;

ConfigurationManagerWindow = Class(Window, function(this, _application)
	Window.init(this, _application, 'Configuration window', false);	
	this:SetWidth(32);
	this:SetHeight(12);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);

	
	local colorConfigurationButton;
	local mouseConfigurationButton;
	local interfaceConfigurationButton;
	local applicationsConfigurationButton;

	local localizationManager;

	local function colorConfigurationButtonClick(_sender, _eventArgs)
		local colorWindow = ColorConfigurationWindow(_application, localizationManager);
		colorWindow:ShowModal();		
	end	

	local function mouseConfigurationButtonClick(_sender, _eventArgs)
		local mouseWindow = MouseConfigurationWindow(_application, localizationManager);
		mouseWindow:ShowModal();		
	end	

	local function interfaceConfigurationButtonClick (_sender, _eventArgs)
		local interfaceWindow = InterfaceConfigurationWindow(_application, localizationManager);
		interfaceWindow:ShowModal();		
	end	

	local function applicationsConfigurationButtonClick (_sender, _eventArgs)
		local applicationsWindow = ApplicationsConfigurationWindow(_application, localizationManager);
		applicationsWindow:ShowModal();		
	end	

	local function localeConfigurationButtonClick(_sender, _eventArgs)
		local localeWindow = LocaleConfigurationWindow(_application, localizationManager);
		localeWindow:ShowModal();		
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		localizationManager = LocalizationManager(fs.combine(this:GetApplication():GetWorkingDirectory(), 'Localizations'), fs.combine(this:GetApplication():GetWorkingDirectory(), 'Localizations/default.xml'));
		localizationManager:ReadLocalization(System:GetSystemLocale());

		this:SetTitle(localizationManager:GetLocalizedString('Title'));

		colorConfigurationButton = Button(localizationManager:GetLocalizedString('Buttons.ColorConfiguration'), nil, nil, 1, 1, 'left-top');
		colorConfigurationButton:AddOnClickEventHandler(colorConfigurationButtonClick);
		this:AddComponent(colorConfigurationButton);
	
		mouseConfigurationButton = Button(localizationManager:GetLocalizedString('Buttons.MouseConfiguration'), nil, nil, 1, 3, 'left-top');
		mouseConfigurationButton:AddOnClickEventHandler(mouseConfigurationButtonClick);
		this:AddComponent(mouseConfigurationButton);	

		interfaceConfigurationButton = Button(localizationManager:GetLocalizedString('Buttons.InterfaceConfiguration'), nil, nil, 1, 5, 'left-top');
		interfaceConfigurationButton:AddOnClickEventHandler(interfaceConfigurationButtonClick);
		this:AddComponent(interfaceConfigurationButton);

		applicationsConfigurationButton = Button(localizationManager:GetLocalizedString('Buttons.ApplicationsConfiguration'), nil, nil, 1, 7, 'left-top');
		applicationsConfigurationButton:AddOnClickEventHandler(applicationsConfigurationButtonClick);
		this:AddComponent(applicationsConfigurationButton);

		localeConfigurationButton = Button(localizationManager:GetLocalizedString('Buttons.LocaleConfiguration'), nil, nil, 1, 9, 'left-top');
		localeConfigurationButton:AddOnClickEventHandler(localeConfigurationButtonClick);
		this:AddComponent(localeConfigurationButton);

		this:SetWidth(colorConfigurationButton:GetWidth() + 4);
	end

	local function constructor()
		initializeComponents();
	end

	constructor();

end)
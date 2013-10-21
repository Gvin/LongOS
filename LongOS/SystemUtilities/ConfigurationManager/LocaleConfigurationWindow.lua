local Button = Classes.Components.Button;
local PopupMenu = Classes.Components.PopupMenu;
local QuestionDialog = Classes.System.Windows.QuestionDialog;

local Window = Classes.Application.Window;

LocaleConfigurationWindow = Class(Window, function(this, _application, _localizationManager)
	Window.init(this, _application, 'Locale configuration window', false);
	this:SetWidth(20);
	this:SetHeight(5);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local changeLocaleButton;
	local changeLocaleMenu;

	local locales;
	local localesDir;
	local selectedLocale;

	local localizationManager;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function getLocalizationFiles(_localesDir)
		local files = fs.list(_localesDir);
		local localeFiles = {};
		for i = 1, #files do
			if (stringExtAPI.getExtension(files[i]) == 'xml') then
				table.insert(localeFiles, files[i]);
			end
		end
		return localeFiles;
	end

	local function getLocaleName(_locale, _localesDir)
		local file = fs.open(fs.combine(_localesDir, _locale..'.xml'), 'r');
		local data = file.readAll();
		file.close();

		local parsed = xmlAPI.parse(data);
		return parsed[1].xarg.name;
	end

	local function parseLocalizationFiles(_localizationFiles)
		local parsed = {};
		for i = 1, #_localizationFiles do
			local code = string.sub(_localizationFiles[i], 1, _localizationFiles[i]:len() - 4);
			local name = getLocaleName(code, localesDir);
			local data = {};
			data.Code = code;
			data.Name = name;
			table.insert(parsed, data);
		end

		return parsed;
	end

	local function rebootDialogOnOk(_sender, _eventArgs)
		System:Reboot();
	end

	local function localeButtonOnClick(_sender, _eventArgs)
		System:SetSystemLocale(_sender.Locale.Code);
		changeLocaleButton:SetText(getLocaleName(System:GetSystemLocale(), localesDir)..' ['..System:GetSystemLocale()..']');

		local rebootDialog = QuestionDialog(this:GetApplication(), 'Reboot?', 'You should reboot you System to change the locale. Reboot now?');
		rebootDialog:AddOnYesEventHandler(rebootDialogOnOk);
		rebootDialog:ShowModal();
	end

	local function windowOnShow(_sender, _eventArgs)
		local localizationFiles = getLocalizationFiles(localesDir);
		locales = parseLocalizationFiles(localizationFiles);

		for i = 1, #locales do
			local button = Button(locales[i].Name..' ['..locales[i].Code..']', nil, nil, 1, i, 'left-top');
			button.Locale = locales[i];
			button:AddOnClickEventHandler(localeButtonOnClick);
			changeLocaleMenu:AddComponent(button);
		end
		changeLocaleMenu.Height = #locales + 2;
	end

	local function changeLocaleButtonOnClick(_sender, _eventArgs)
		changeLocaleMenu.X = _sender:GetX();
		changeLocaleMenu.Y = _sender:GetY() + 1;
		changeLocaleMenu:OpenClose();
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		this:SetTitle('Change locale')

		this:AddOnShowEventHandler(windowOnShow);

		changeLocaleButton = Button(getLocaleName(System:GetSystemLocale(), localesDir)..' ['..System:GetSystemLocale()..']', nil, nil, 1, 1, 'left-top');
		changeLocaleButton:AddOnClickEventHandler(changeLocaleButtonOnClick);
		this:AddComponent(changeLocaleButton);

		changeLocaleMenu = PopupMenu(1, 1, 10, 10, nil, false);
		this:AddMenu('LocaleMenu', changeLocaleMenu);
	end

	local function constructor(_localizationManager)
		localizationManager = _localizationManager;

		localesDir = System:ResolvePath('%SYSDIR%/Localizations/');
		selectedLocale = System:GetSystemLocale();

		initializeComponents();
	end

	constructor(_localizationManager);
end)
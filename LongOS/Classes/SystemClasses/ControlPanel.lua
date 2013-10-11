local Button = Classes.Components.Button;
local PopupMenu = Classes.Components.PopupMenu;
local Label = Classes.Components.Label;

local ComponentsManager = Classes.Application.ComponentsManager;
local MenuesManager = Classes.Application.MenuesManager;


Classes.System.ControlPanel = Class(Object, function(this)
	Object.init(this, 'ControlPanel');

	this.IsBottom = true;

	local componentsManager = ComponentsManager();
	local menuesManager = MenuesManager();
	local screenWidth, screenHeight = term.getSize();

	-- POWER

	local powerMenu = PopupMenu(40, 12, 15, 7, colors.lightGray);
	menuesManager:AddMenu('PowerMenu', powerMenu);

	local shutdownButtonClick = function(sender, eventArgs)
		System:Shutdown();
	end

	local shutdownButton = Button(System:GetLocalizedString('System.ControlPanel.Buttons.Shutdown'), colors.red, colors.black, 1, 1, 'left-top');
	shutdownButton:AddOnClickEventHandler(shutdownButtonClick);
	powerMenu:AddComponent(shutdownButton);

	local rebootButtonClick = function(sender, eventArgs)
		System:Reboot();
	end

	local rebootButton = Button(System:GetLocalizedString('System.ControlPanel.Buttons.Reboot'), colors.lightBlue, colors.black, 1, 3, 'left-top');
	rebootButton:AddOnClickEventHandler(rebootButtonClick);
	powerMenu:AddComponent(rebootButton);

	local logOffButtonClick = function(sender, eventArgs)
		System:LogOff();
	end

	local logOffButton = Button(System:GetLocalizedString('System.ControlPanel.Buttons.LogOff'), colors.lime, colors.black, 1, 5, 'left-top');
	logOffButton:AddOnClickEventHandler(logOffButtonClick);
	powerMenu:AddComponent(logOffButton);

	local powerButtonClick = function(sender, eventArgs)
		menuesManager:OpenCloseMenu('PowerMenu');
	end

	local powerButton = Button(System:GetLocalizedString('System.ControlPanel.Buttons.Power'), colors.red, colors.black, 7, 0, 'right-top');
	powerButton:AddOnClickEventHandler(powerButtonClick);
	componentsManager:AddComponent(powerButton);

	-- APPLICATIONS

	local applicationsMenu = PopupMenu(2, 18, 14, 1, colors.lightGray);
	menuesManager:AddMenu('ApplicationsMenu', applicationsMenu);

	local applicationsButtonClick = function(sender, eventArgs)
		menuesManager:OpenCloseMenu('ApplicationsMenu');
	end

	local applicationsButton = Button(System:GetLocalizedString('System.ControlPanel.Buttons.Applications'), colors.lime, colors.black, 1, 0, 'left-top');
	applicationsButton:AddOnClickEventHandler(applicationsButtonClick);
	componentsManager:AddComponent(applicationsButton);

	-- SYSTEM

	local systemMenu = PopupMenu(15, 14, 15, 9, colors.lightGray);
	menuesManager:AddMenu('SystemMenu', systemMenu);

	local tasksManagerButtonClick = function(sender, eventArgs)
		System:RunFile('%SYSDIR%/SystemUtilities/TasksManager/GvinTasksManager.exec');
	end

	local tasksManagerButton = Button(System:GetLocalizedString('System.ControlPanel.Applications.TasksManager'), colors.gray, colors.white, 1, 3, 'left-top');
	tasksManagerButton:AddOnClickEventHandler(tasksManagerButtonClick);
	systemMenu:AddComponent(tasksManagerButton);

	local configurationButtonClick = function(sender, eventArgs)
		System:RunFile('%SYSDIR%/SystemUtilities/ConfigurationManager/ConfigurationManager.exec');
	end

	local configurationButton = Button(System:GetLocalizedString('System.ControlPanel.Applications.Configuration'), colors.gray, colors.white, 1, 1, 'left-top');
	configurationButton:AddOnClickEventHandler(configurationButtonClick);
	systemMenu:AddComponent(configurationButton);

	local terminalButtonClick = function(sender, eventArgs)
		System:RunFile('%SYSDIR%/SystemUtilities/Terminal/GvinTerminal.exec');
	end

	local terminalButton = Button(System:GetLocalizedString('System.ControlPanel.Applications.Terminal'), colors.gray, colors.white, 1, 5, 'left-top');
	terminalButton:AddOnClickEventHandler(terminalButtonClick);
	systemMenu:AddComponent(terminalButton);

	local aboutSystemButtonClick = function(sender, eventArgs)
		System:RunFile('%SYSDIR%/SystemUtilities/AboutSystem/AboutSystem.exec');
	end

	local aboutSystemButton = Button(System:GetLocalizedString('System.ControlPanel.Applications.AboutSystem'), colors.gray, colors.white, 1, 7, 'left-top');
	aboutSystemButton:AddOnClickEventHandler(aboutSystemButtonClick);
	systemMenu:AddComponent(aboutSystemButton);

	local systemButtonClick = function(sender, eventArgs)
		menuesManager:OpenCloseMenu('SystemMenu');
	end

	local systemButton = Button(System:GetLocalizedString('System.ControlPanel.Buttons.System'), colors.lime, colors.black, string.len(applicationsButton:GetText()) + 2, 0, 'left-top');
	systemButton:AddOnClickEventHandler(systemButtonClick);
	componentsManager:AddComponent(systemButton);

	-- TIME

	local calendarMenu = PopupMenu(42, 2, 6, 4, colors.lightGray, false);
	menuesManager:AddMenu('CalendarMenu', calendarMenu);

	local dayLabel = Label(System:GetLocalizedString('System.ControlPanel.Calendar.Day')..' ----', colors.lightGray, colors.black, 1, 1, 'left-top');
	calendarMenu:AddComponent(dayLabel);

	local yearLabel = Label(System:GetLocalizedString('System.ControlPanel.Calendar.Year')..' ---', colors.lightGray, colors.black, 1, 2, 'left-top');
	calendarMenu:AddComponent(yearLabel);

	local calendarButtonClick = function(sender, eventArgs)
		menuesManager:OpenCloseMenu('CalendarMenu');
	end

	local calendarButton = Button('--:--', colors.green, colors.white, 1, 0, 'right-top');
	calendarButton:AddOnClickEventHandler(calendarButtonClick);
	componentsManager:AddComponent(calendarButton);
	
	local drawControlPanel = function(videoBuffer)
		local colorConfiguration = System:GetColorConfiguration();
		applicationsButton:SetBackgroundColor(colorConfiguration:GetColor('ControlPanelButtonsColor'));
		systemButton:SetBackgroundColor(colorConfiguration:GetColor('ControlPanelButtonsColor'));
		powerButton:SetBackgroundColor(colorConfiguration:GetColor('ControlPanelPowerButtonColor'));
		calendarButton:SetBackgroundColor(colorConfiguration:GetColor('ControlPanelColor'));
		calendarButton:SetTextColor(colorConfiguration:GetColor('TimeTextColor'));
		dayLabel:SetBackgroundColor(colorConfiguration:GetColor('WindowColor'));
		dayLabel:SetTextColor(colorConfiguration:GetColor('SystemLabelsTextColor'));
		yearLabel:SetBackgroundColor(colorConfiguration:GetColor('WindowColor'));
		yearLabel:SetTextColor(colorConfiguration:GetColor('SystemLabelsTextColor'));

		configurationButton:SetBackgroundColor(colorConfiguration:GetColor('SystemButtonsColor'));
		configurationButton:SetTextColor(colorConfiguration:GetColor('SystemButtonsTextColor'));
		tasksManagerButton:SetBackgroundColor(colorConfiguration:GetColor('SystemButtonsColor'));
		tasksManagerButton:SetTextColor(colorConfiguration:GetColor('SystemButtonsTextColor'));
		terminalButton:SetBackgroundColor(colorConfiguration:GetColor('SystemButtonsColor'));
		terminalButton:SetTextColor(colorConfiguration:GetColor('SystemButtonsTextColor'));
		aboutSystemButton:SetBackgroundColor(colorConfiguration:GetColor('SystemButtonsColor'));
		aboutSystemButton:SetTextColor(colorConfiguration:GetColor('SystemButtonsTextColor'));
		powerMenu.X = powerButton:GetX();
		calendarMenu.X = calendarButton:GetX() - 4;

		local line = 1;
		if (this.IsBottom) then
			line = screenHeight;
		end

		videoBuffer:DrawBlock(1, line, screenWidth, 1, colorConfiguration:GetColor('ControlPanelColor'));
		
		calendarButton:SetText(System:GetCurrentTime());

		local days = os.day();
		local years = math.floor(days/366) + 1;
		days = days - (years - 1)*365;

		local day = days..'';
		local dayText = System:GetLocalizedString('System.ControlPanel.Calendar.Day');
		while (string.len(day) < 4 + (dayText:len() - 3)) do
			day = ' '..day;
		end

		local year = years..'';
		local yearText = System:GetLocalizedString('System.ControlPanel.Calendar.Year');
		while (string.len(year) < 3 + (yearText:len() - 4)) do
			year = ' '..year;
		end
		dayLabel:SetText(dayText..' '..day);
		yearLabel:SetText(yearText..' '..year);

		componentsManager:Draw(videoBuffer, 1, line, screenWidth, 1);
	end

	local alignMenu = function(menu)
		if (this.IsBottom) then
			menu.Y = screenHeight - menu.Height;
		else
			menu.Y = 2;
		end
	end

	-- Draw bottom menu on the screen.
	this.Draw = function(_, videoBuffer)		
		local interfaceConfiguration = System:GetInterfaceConfiguration();
		this.IsBottom = interfaceConfiguration:GetOption('ControlPanelPosition') == 'bottom';
		drawControlPanel(videoBuffer);		
		menuesManager:ForEach(alignMenu);
		menuesManager:Draw(videoBuffer);
	end

	-- Process left click event caught by system.
	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		if (componentsManager:ProcessLeftClickEvent(cursorX, cursorY)) then
			return true;
		end

		if (menuesManager:ProcessLeftClickEvent(cursorX, cursorY)) then
			return true;
		end

		return false;
	end

	local applicationButtonClick = function(sender, eventArgs)
		local path = sender.Path;
		if (sender.Terminal == true) then
			path = '%SYSDIR%/SystemUtilities/Terminal/GvinTerminal.exec '..path;
		end
		System:RunFile(path);
	end

	-- Add new applications to the "Applications" menu.
	-- Added application will only be a new button which runs program at the specified path.

	local function addApplication(_applicationName, _applicationPath, _useTerminal)
		applicationsMenu.Y = applicationsMenu.Y - 2;
		applicationsMenu.Height = applicationsMenu.Height + 2;

		local applicationButton = Button(_applicationName, nil, nil, 1, applicationsMenu.Height - 2, 'left-top');
		applicationButton.Path = _applicationPath;
		if (_useTerminal == 'true') then
			applicationButton.Terminal = true;
		else
			applicationButton.Terminal = false;	
		end
		applicationButton:AddOnClickEventHandler(applicationButtonClick);

		applicationsMenu:AddComponent(applicationButton);
	end
	
	function this:RefreshApplications()		
		local applicationsConfiguration = System:GetApplicationsConfiguration();
		local applications = applicationsConfiguration:GetApplicationsData();
		applicationsMenu:Clear();		
		for i = 1, #applications do			
			local name = applications[i][1];
			local path = applications[i][2];
			local terminal = applications[i][3];
			addApplication(name, path, terminal);		
		end
	end

	
end)
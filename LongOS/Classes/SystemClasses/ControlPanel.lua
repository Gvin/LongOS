local Button = Classes.Components.Button;
local PopupMenu = Classes.Components.PopupMenu;
local Label = Classes.Components.Label;

local ComponentsManager = Classes.Application.ComponentsManager;
local MenuesManager = Classes.Application.MenuesManager;


ControlPanel = Class(Object, function(this)
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

	local shutdownButton = Button('Shutdown', colors.red, colors.black, 1, 1, 'left-top');
	shutdownButton:AddOnClickEventHandler(shutdownButtonClick);
	powerMenu:AddComponent(shutdownButton);

	local rebootButtonClick = function(sender, eventArgs)
		System:Reboot();
	end

	local rebootButton = Button('Reboot', colors.lightBlue, colors.black, 2, 3, 'left-top');
	rebootButton:AddOnClickEventHandler(rebootButtonClick);
	powerMenu:AddComponent(rebootButton);

	local logOffButtonClick = function(sender, eventArgs)
		System:LogOff();
	end

	local logOffButton = Button('Log  off', colors.lime, colors.black, 1, 5, 'left-top');
	logOffButton:AddOnClickEventHandler(logOffButtonClick);
	powerMenu:AddComponent(logOffButton);

	local powerButtonClick = function(sender, eventArgs)
		menuesManager:OpenCloseMenu('PowerMenu');
	end

	local powerButton = Button('Power', colors.red, colors.black, 7, 0, 'right-top');
	powerButton:AddOnClickEventHandler(powerButtonClick);
	componentsManager:AddComponent(powerButton);

	-- APPLICATIONS

	local applicationsMenu = PopupMenu(2, 18, 14, 1, colors.lightGray);
	menuesManager:AddMenu('ApplicationsMenu', applicationsMenu);

	local applicationsButtonClick = function(sender, eventArgs)
		menuesManager:OpenCloseMenu('ApplicationsMenu');
	end

	local applicationsButton = Button('Applications', colors.lime, colors.black, 1, 0, 'left-top');
	applicationsButton:AddOnClickEventHandler(applicationsButtonClick);
	componentsManager:AddComponent(applicationsButton);

	-- SYSTEM

	local systemMenu = PopupMenu(15, 14, 15, 7, colors.lightGray);
	menuesManager:AddMenu('SystemMenu', systemMenu);

	local tasksManagerButtonClick = function(sender, eventArgs)
		System:RunFile('/LongOS/SystemUtilities/TasksManager/GvinTasksManager.exec');
	end

	local tasksManagerButton = Button('Tasks manager', colors.gray, colors.white, 1, 3, 'left-top');
	tasksManagerButton:AddOnClickEventHandler(tasksManagerButtonClick);
	systemMenu:AddComponent(tasksManagerButton);

	local configurationButtonClick = function(sender, eventArgs)
		System:RunFile('/LongOS/SystemUtilities/ConfigurationManager/ConfigurationManager.exec');
	end

	local configurationButton = Button('Configuration', colors.gray, colors.white, 1, 1, 'left-top');
	configurationButton:AddOnClickEventHandler(configurationButtonClick);
	systemMenu:AddComponent(configurationButton);

	local terminalButtonClick = function(sender, eventArgs)
		System:RunFile('/LongOS/SystemUtilities/Terminal/GvinTerminal.exec');
	end

	local terminalButton = Button('Terminal', colors.gray, colors.white, 3, 5, 'left-top');
	terminalButton:AddOnClickEventHandler(terminalButtonClick);
	systemMenu:AddComponent(terminalButton);

	local systemButtonClick = function(sender, eventArgs)
		menuesManager:OpenCloseMenu('SystemMenu');
	end

	local systemButton = Button('System', colors.lime, colors.black, 14, 0, 'left-top');
	systemButton:AddOnClickEventHandler(systemButtonClick);
	componentsManager:AddComponent(systemButton);

	-- TIME

	local calendarMenu = PopupMenu(42, 2, 6, 4, colors.lightGray, false);
	menuesManager:AddMenu('CalendarMenu', calendarMenu);

	local dayLabel = Label('Day ----', colors.lightGray, colors.black, 1, 1, 'left-top');
	calendarMenu:AddComponent(dayLabel);

	local yearLabel = Label('Year ---', colors.lightGray, colors.black, 1, 2, 'left-top');
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
		powerMenu.X = powerButton:GetX();
		calendarMenu.X = calendarButton:GetX() - 4;

		local line = 1;
		if (this.IsBottom) then
			line = screenHeight;
		end

		videoBuffer:DrawBlock(1, line, screenWidth, 1, colorConfiguration:GetColor('ControlPanelColor'));
		
		calendarButton:SetText(System:GetCurrentTime());

		local days = os.day();
		local years = math.floor(days/365);
		days = days - years*365;

		local day = days..'';
		while (string.len(day) < 4) do
			day = ' '..day;
		end
		local year = years..'';
		while (string.len(year) < 3) do
			year = ' '..year;
		end
		dayLabel:SetText('Day '..day);
		yearLabel:SetText('Year '..year);

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
		ERR = sender;
		local path = sender.Path;
		if (sender.Terminal == true) then
			path = '/LongOS/SystemUtilities/Terminal/GvinTerminal.exec '..path;
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
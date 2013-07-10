local function shutdown()
	System:Shutdown();
end

local function reboot()
	System:Reboot();
end

local function logOff()
	System:LogOff();
end

local function configurationButtonClick()
	System:ShowConfigurationWindow();
end

local function tasksManagerButtonClick()
	System:RunFile('/LongOS/Utilities/TasksManager/GvinTasksManager');
end

local function launchApplication(params)
	System:RunFile(params[1]);
end

local function openMenu(params)
	params[1]:OpenCloseMenu(params[2]);
end

ControlPanel = Class(function(this)
	this.ClassName = 'ControlPanel';

	this.IsBottom = true;

	local componentsManager = ComponentsManager();
	local menuesManager = MenuesManager();
	local screenWidth, screenHeight = term.getSize();

	-- POWER

	local powerMenu = PopupMenu(40, 12, 15, 7, colors.lightGray);
	menuesManager:AddMenu('PowerMenu', powerMenu);

	local shutdownButton = Button('Shutdown', colors.red, colors.black, 1, -6, 'left-bottom');
	shutdownButton.OnClick = shutdown;
	powerMenu:AddComponent(shutdownButton);

	local rebootButton = Button('Reboot', colors.blue, colors.black, 2, -4, 'left-bottom');
	rebootButton.OnClick = reboot;
	powerMenu:AddComponent(rebootButton);

	local logOffButton = Button('Log  off', colors.lime, colors.black, 1, -2, 'left-bottom');
	logOffButton.OnClick = logOff;
	powerMenu:AddComponent(logOffButton);

	local powerButton = Button('Power', colors.red, colors.black, -14, 0, 'right-top');
	powerButton.OnClick = openMenu;
	powerButton.OnClickParams = { menuesManager, 'PowerMenu' };
	componentsManager:AddComponent(powerButton);

	-- APPLICATIONS

	local applicationsMenu = PopupMenu(2, 18, 14, 1, colors.lightGray);
	menuesManager:AddMenu('ApplicationsMenu', applicationsMenu);

	local applicationsButton = Button('Applications', colors.lime, colors.black, 1, 0, 'left-top');
	applicationsButton.OnClick = openMenu;
	applicationsButton.OnClickParams = { menuesManager, 'ApplicationsMenu' };
	componentsManager:AddComponent(applicationsButton);

	-- SYSTEM

	local systemMenu = PopupMenu(15, 14, 15, 5, colors.lightGray);
	menuesManager:AddMenu('SystemMenu', systemMenu);

	local tasksManagerButton = Button('Tasks manager', colors.gray, colors.white, 1, -2, 'left-bottom');
	tasksManagerButton.OnClick = tasksManagerButtonClick;
	systemMenu:AddComponent(tasksManagerButton);

	local configurationButton = Button('Configuration', colors.gray, colors.white, 1, -4, 'left-bottom');
	configurationButton.OnClick = configurationButtonClick;
	systemMenu:AddComponent(configurationButton);

	local systemButton = Button('System', colors.lime, colors.black, 14, 0, 'left-top');
	systemButton.OnClick = openMenu;
	systemButton.OnClickParams = { menuesManager, 'SystemMenu' };
	componentsManager:AddComponent(systemButton);

	-- TIME

	local calendarMenu = PopupMenu(42, 2, 6, 4, colors.lightGray, false);
	menuesManager:AddMenu('CalendarMenu', calendarMenu);

	local dayLabel = Label('Day ----', colors.lightGray, colors.black, 1, 1, 'left-top');
	calendarMenu:AddComponent(dayLabel);

	local yearLabel = Label('Year ---', colors.lightGray, colors.black, 1, 2, 'left-top');
	calendarMenu:AddComponent(yearLabel);

	local calendarButton = Button('--:--', colors.green, colors.white, -6, 0, 'right-top');
	calendarButton.OnClick = openMenu;
	calendarButton.OnClickParams = { menuesManager, 'CalendarMenu' };
	componentsManager:AddComponent(calendarButton);

	-- MODEM MANAGER

	local modemLetter = 'X';
	local modemColor = colors.blue;
	local modemLabel = Label(modemLetter, modemColor, colors.white, -8, 0, 'right-top');
	componentsManager:AddComponent(modemLabel);
	
	local drawControlPanel = function(videoBuffer)
		applicationsButton.BackgroundColor = System:GetSystemColor('ControlPanelButtonsColor');
		systemButton.BackgroundColor = System:GetSystemColor('ControlPanelButtonsColor');
		powerButton.BackgroundColor = System:GetSystemColor('ControlPanelPowerButtonColor');
		calendarButton.BackgroundColor = System:GetSystemColor('ControlPanelColor');
		calendarButton.TextColor = System:GetSystemColor('TimeTextColor');
		dayLabel.BackgroundColor = System:GetSystemColor('WindowColor');
		dayLabel.TextColor = System:GetSystemColor('SystemLabelsTextColor');
		yearLabel.BackgroundColor = System:GetSystemColor('WindowColor');
		yearLabel.TextColor = System:GetSystemColor('SystemLabelsTextColor');

		configurationButton.BackgroundColor = System:GetSystemColor('SystemButtonsColor');
		configurationButton.TextColor = System:GetSystemColor('SystemButtonsTextColor');
		tasksManagerButton.BackgroundColor = System:GetSystemColor('SystemButtonsColor');
		tasksManagerButton.TextColor = System:GetSystemColor('SystemButtonsTextColor');
		powerMenu.X = powerButton.X;
		calendarMenu.X = calendarButton.X - 4;

		local line = 1;
		if (this.IsBottom) then
			line = screenHeight;
		end

		videoBuffer:DrawBlock(1, line, screenWidth, 1, System:GetSystemColor('ControlPanelColor'));
		
		calendarButton.Text = System:GetCurrentTime();

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
		dayLabel.Text = 'Day '..day;
		yearLabel.Text = 'Year '..year;

		local modemMonitor = System:GetModemMonitor();
		if (modemMonitor:IsModemConnected()) then
			modemLetter = 'M';
			if (modemMonitor:IsModemEnabled()) then
				modemColor = colors.red;
			else
				modemColor = colors.gray;
			end
		else
			modemLetter = 'X';
			modemColor = colors.gray;
		end

		modemLabel.BackgroundColor = modemColor;
		modemLabel.Text = modemLetter;

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
		this.IsBottom = System:GetInterfaceOption('ControlPanelPosition') == 'bottom';
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

	-- Add new applications to the "Applications" menu.
	-- Added application will only be a new button which runs program at the specified path.
	this.AddApplication = function(_, applicationName, applicationPath)
		applicationsMenu.Y = applicationsMenu.Y - 2;
		applicationsMenu.Height = applicationsMenu.Height + 2;
		local applicationButton = Button(applicationName, nil, nil, 1, -(applicationsMenu.Height - 1), 'left-bottom');
		applicationButton.OnClick = launchApplication;
		applicationButton.OnClickParams = { applicationPath };
		applicationsMenu:AddComponent(applicationButton);
	end
end)
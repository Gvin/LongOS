ControlPanel = Class(function(this)
	
	this.GetClassName = function()
		return 'ControlPanel';
	end

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

	local shutdownButton = Button('Shutdown', colors.red, colors.black, 1, -6, 'left-bottom');
	shutdownButton:SetOnClick(shutdownButtonClick);
	powerMenu:AddComponent(shutdownButton);

	local rebootButtonClick = function(sender, eventArgs)
		System:Reboot();
	end

	local rebootButton = Button('Reboot', colors.lightBlue, colors.black, 2, -4, 'left-bottom');
	rebootButton:SetOnClick(rebootButtonClick);
	powerMenu:AddComponent(rebootButton);

	local logOffButtonClick = function(sender, eventArgs)
		System:LogOff();
	end

	local logOffButton = Button('Log  off', colors.lime, colors.black, 1, -2, 'left-bottom');
	logOffButton:SetOnClick(logOffButtonClick);
	powerMenu:AddComponent(logOffButton);

	local powerButtonClick = function(sender, eventArgs)
		menuesManager:OpenCloseMenu('PowerMenu');
	end

	local powerButton = Button('Power', colors.red, colors.black, -12, 0, 'right-top');
	powerButton:SetOnClick(powerButtonClick);
	componentsManager:AddComponent(powerButton);

	-- APPLICATIONS

	local applicationsMenu = PopupMenu(2, 18, 14, 1, colors.lightGray);
	menuesManager:AddMenu('ApplicationsMenu', applicationsMenu);

	local applicationsButtonClick = function(sender, eventArgs)
		menuesManager:OpenCloseMenu('ApplicationsMenu');
	end

	local applicationsButton = Button('Applications', colors.lime, colors.black, 1, 0, 'left-top');
	applicationsButton:SetOnClick(applicationsButtonClick);
	componentsManager:AddComponent(applicationsButton);

	-- SYSTEM

	local systemMenu = PopupMenu(15, 14, 15, 5, colors.lightGray);
	menuesManager:AddMenu('SystemMenu', systemMenu);

	local tasksManagerButtonClick = function(sender, eventArgs)
		System:RunFile('/LongOS/SystemUtilities/TasksManager/GvinTasksManager');
	end

	local tasksManagerButton = Button('Tasks manager', colors.gray, colors.white, 1, -2, 'left-bottom');
	tasksManagerButton:SetOnClick(tasksManagerButtonClick);
	systemMenu:AddComponent(tasksManagerButton);

	local configurationButtonClick = function(sender, eventArgs)
		System:RunFile('/LongOS/SystemUtilities/ConfigurationManager/ConfigurationManager');
	end

	local configurationButton = Button('Configuration', colors.gray, colors.white, 1, -4, 'left-bottom');
	configurationButton:SetOnClick(configurationButtonClick);
	systemMenu:AddComponent(configurationButton);

	local systemButtonClick = function(sender, eventArgs)
		menuesManager:OpenCloseMenu('SystemMenu');
	end

	local systemButton = Button('System', colors.lime, colors.black, 14, 0, 'left-top');
	systemButton:SetOnClick(systemButtonClick);
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

	local calendarButton = Button('--:--', colors.green, colors.white, -6, 0, 'right-top');
	calendarButton:SetOnClick(calendarButtonClick);
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
		dayLabel.Text = 'Day '..day;
		yearLabel.Text = 'Year '..year;

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
		System:RunFile(sender.Path);
	end

	-- Add new applications to the "Applications" menu.
	-- Added application will only be a new button which runs program at the specified path.
	this.AddApplication = function(_, applicationName, applicationPath)
		applicationsMenu.Y = applicationsMenu.Y - 2;
		applicationsMenu.Height = applicationsMenu.Height + 2;

		local applicationButton = Button(applicationName, nil, nil, 1, -(applicationsMenu.Height - 1), 'left-bottom');
		applicationButton.Path = applicationPath;
		applicationButton:SetOnClick(applicationButtonClick);

		applicationsMenu:AddComponent(applicationButton);
	end
end)
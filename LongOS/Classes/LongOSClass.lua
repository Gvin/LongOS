LongOS = Class(function(this)
	this.ClassName = 'LongOS';

	local updateLock = false;

	local colorConfiguration = Configuration();
	local interfaceConfiguration = Configuration();
	local mouseConfiguration = Configuration();

	local runtimeLog = Logger('/LongOS/Logs/runtime.log');

	local videoBuffer = VideoBuffer();

	local applicationsManager = ApplicationsManager();

	local modemMonitor = ModemMonitor();

	local desktopManager = Desktop();

	local controlPanel = ControlPanel();

	local initApplication = Application('Init', true, false);
	applicationsManager:AddApplication(initApplication);

	local working = true;

	local currentVersion = '0.1';

	local dblClickTimer = 0;
	local clickX = 0;
	local clickY = 0;

	local timers = {};
	local eventsQueue = {};

	this.LogRuntimeError = function(_, errorText)
		runtimeLog:LogError(errorText);
	end

	-- Get if system is still working.
	this.GetWorking = function()
		return working;
	end

	this.GetModemMonitor = function(_)
		return modemMonitor;
	end

	-- Add new applications to the applications manager.
	this.AddApplication = function(_, application)
		applicationsManager:AddApplication(application);
	end

	-- Delete existing application from the applications manager.
	this.DeleteApplication = function(_, applicationId)
		applicationsManager:DeleteApplication(applicationId);
	end

	this.SetCurrentApplication = function(_, applicationId)
		applicationsManager:SetCurrentApplication(applicationId);
	end

	-- Get current version of LongOS.
	this.GetCurrentVersion = function()
		return currentVersion;
	end

	-- Update system's state.
	this.Update = function()
		updateLock = true;
		modemMonitor:Update();
		applicationsManager:Update();
		updateLock = false;

		if (dblClickTimer > 0) then
			dblClickTimer = dblClickTimer - 1;
		end
	end
	
	-- Draw system.
	this.Draw = function()
		if (not updateLock) then
			if (desktopManager.FileName ~= interfaceConfiguration:GetValue('WallpaperFileName')) then
				desktopManager:LoadWallpaper(interfaceConfiguration:GetValue('WallpaperFileName'));
			end
			
			videoBuffer:SetCursorBlink(false);

			desktopManager:Draw(videoBuffer);
			applicationsManager:Draw(videoBuffer);
			controlPanel:Draw(videoBuffer);

			videoBuffer:Draw();
		end
	end

	local  function processDoubleClickEvent(cursorX, cursorY)
		applicationsManager:ProcessDoubleClickEvent(cursorX, cursorY);
	end

	local function processLeftClickEvent(cursorX, cursorY)
		if (dblClickTimer > 0 and clickX == cursorX and clickY == cursorY) then
			processDoubleClickEvent(cursorX, cursorY);
			return;
		end

		dblClickTimer = mouseConfiguration:GetValue('DoubleClickSpeed') + 0;
		clickX = cursorX;
		clickY = cursorY;

		desktopManager:ProcessLeftClickEvent(cursorX, cursorY);
		if (controlPanel:ProcessLeftClickEvent(cursorX, cursorY)) then
			return;
		end
		applicationsManager:ProcessLeftClickEvent(cursorX, cursorY);
	end

	local function processRightClickEvent(cursorX, cursorY)
		if (applicationsManager:ProcessRightClickEvent(cursorX, cursorY)) then
			return;
		end
		desktopManager:ProcessRightClickEvent(cursorX, cursorY);
		
	end

	local function processMouseClickEvent(button, cursorX, cursorY)
		if (button == 1) then -- If left mouse click
			processLeftClickEvent(cursorX, cursorY);
		else -- If right mouse click
			processRightClickEvent(cursorX, cursorY);
		end
	end

	local function processTabKey()
		applicationsManager:SwitchApplication();
	end

	local function processKeys(key)
		if (key == 15) then ------------- Tab
			processTabKey();
		else
			applicationsManager:ProcessKeyEvent(key);
		end
	end

	local function processCharEvent(char)
		applicationsManager:ProcessCharEvent(char);
	end

	local function processRednetEvent(id, message, distance)
		applicationsManager:ProcessRednetEvent(id, message, distance);
	end

	this.AddTimer = function(_, timer)
		if (timer:GetEnabled()) then
			local timerId = os.startTimer(timer.Interval);
			timers[timerId..''] = timer;
		end
	end

	local function processTimerEvent(timerId)
		for key, v in pairs(timers) do
			if (key == timerId..'') then
				local timer = timers[key];
				timer:Tick();
				timers[key] = nil;
				this:AddTimer(timer);
				return;
			end
		end
	end

	-- Process events from events queue.
	this.ProcessEvents = function()
		if (#eventsQueue > 0) then
			local event = eventsQueue[1];
			if (event.Name == 'mouse_click') then
				processMouseClickEvent(event.Params[1], event.Params[2], event.Params[3]);
			elseif (event.Name == 'key') then
				processKeys(event.Params[1]);
			elseif (event.Name == 'char') then
				processCharEvent(event.Params[1]);
			elseif (event.Name == 'modem_message') then
				processRednetEvent(event.Params[3], event.Params[4], event.Params[5]);
			elseif (event.Name == 'timer') then
				processTimerEvent(event.Params[1]);
			end
			table.remove(eventsQueue, 1);
		else
			os.sleep(0.1);
		end
	end

	local addEvent = function(eventName, params)
		local event = {};
		event.Name = eventName;
		event.Params = params;
		table.insert(eventsQueue, event);
	end

	-- Catch incoming events.
	this.CatchEvents = function()
		local event, param1, param2, param3, param4, param5 = os.pullEvent();
		addEvent(event, { param1, param2, param3, param4, param5 });
	end

	-- Shutdown computer.
	this.Shutdown = function()
		os.shutdown();
	end

	-- Reboot computer.
	this.Reboot = function()
		os.reboot();
	end

	-- Log off from computer.
	this.LogOff = function()
		working = false;
		term.setBackgroundColor(colors.black);
		term.setTextColor(colors.white);
		term.clear();
		term.setCursorPos(1, 1);
		print('LongOS closed.');
	end

	-- Show message window with selected title, message and text color.
	this.ShowMessage = function(_, title, text, textColor)
		applicationsManager:SetCurrentApplication(initApplication.Id);
		local messageWindow = MessageWindow(initApplication, title, text, textColor);
		messageWindow:Show();
	end

	this.ShowModalMessage = function(_, application, title, text, textColor)
		applicationsManager:SetCurrentApplication(application.Id);
		local messageWindow = MessageWindow(application, title, text, textColor);
		messageWindow:Show();
	end

	this.ShowError = function(_, message)
		if (message == nil) then
			message = 'No message.';
		end
		this:ShowMessage('Error', 'Error message: '..message, colors.red);
	end

	-- Get current time in string format.
	this.GetCurrentTime = function(_)
		local nTime = os.time();
		local sTime = textutils.formatTime(nTime, true);
		if (string.len(sTime) < 5) then
			sTime = '0'..sTime;
		end

		return sTime;
	end

	local generateIdPart = function()
		local selector = math.random(0, 2);
		if (selector == 1) then
			return string.char(math.random(48, 57));
		elseif (selector == 2) then
			return string.char(math.random(65, 90));
		else
			return string.char(math.random(97, 122));
		end
	end

	-- Generate uniqie Id.
	this.GenerateId = function()
		local result = '';
		for i = 1, 20 do
			result = result..generateIdPart();
		end

		return result;
	end

	-- Try to execute some function without parameters.
	this.Try = function(_, func)
		local sucess, message = pcall(func);
		if (not sucess) then
			if (message == nil) then
				message = 'No message.';
			end
			System:LogRuntimeError('Error while trying to run function. Message:"'..message..'".');
			this:ShowMessage('Error', 'Error message: '..message, colors.red);
			return false;
		end

		return true;
	end

	this.TryParams = function(_, func, params)
		local sucess, message = pcall(func, params);
		if (not sucess) then
			if (message == nil) then
				message = 'No message.';
			end
			System:LogRuntimeError('Error while trying to run function. Message:"'..message..'".');
			this:ShowMessage('Error', 'Error message: '..message, colors.red);
			return false;
		end

		return true;
	end

	-- Get current applications count.
	this.GetApplicationsCount = function(_)
		return applicationsManager:GetApplicationsCount();
	end

	-- Get applications list.
	-- This list only contains some data about applications, not the applications itself.
	this.GetApplicationsList = function(_)
		return applicationsManager:GetApplicationsList();
	end

	-- Run selected file in error-catching mode.
	this.RunFile = function(_, fileName)
		local sucess = shell.run(fileName);
		if (not sucess) then
			this:ShowMessage('Error', 'Errors occured when running file "'..fileName..'".', colors.red);
		end
	end

	local loadApplicationsConfiguration = function()
		local file = fs.open('/LongOS/Configuration/applications.config', 'r');
		local name = file.readLine();
		while (name ~= nil) do
			local path = file.readLine();
			controlPanel:AddApplication(name, path);
			name = file.readLine();
		end

		file.close();
	end

	-- Load color scheme configuration from file.
	this.LoadColorSchemaConfiguration = function()
		colorConfiguration:ReadConfiguration('/LongOS/Configuration/color_schema.config');
	end

	this.LoadInterfaceConfiguration = function()
		interfaceConfiguration:ReadConfiguration('/LongOS/Configuration/interface.config');
	end

	-- Load all system configuration.
	this.LoadConfiguration = function(_)
		this:LoadColorSchemaConfiguration();
		this:LoadInterfaceConfiguration();
		loadApplicationsConfiguration();
		mouseConfiguration:ReadConfiguration('/LongOS/Configuration/mouse.config');
	end

	-- Get color from system pallete by it's name.
	this.GetSystemColor = function(_, name)
		return colorConfiguration:GetValue(name) + 0;
	end

	-- Set color in system pallete by it's name.
	this.SetSystemColor = function(_, name, value)
		colorConfiguration:SetValue(name, value);
	end

	this.GetInterfaceOption = function(_, name)
		return interfaceConfiguration:GetValue(name);
	end

	this.SetInterfaceOption = function(_, name, value)
		interfaceConfiguration:SetValue(name, value);
	end

	-- Save current color scheme configuration to the configuration file.
	this.SaveColorSchemaConfiguration = function(_)
		colorConfiguration:WriteConfiguration('/LongOS/Configuration/color_schema.config');
	end

	this.SaveInterfaceConfiguration = function()
		interfaceConfiguration:WriteConfiguration('/LongOS/Configuration/interface.config');
	end

	-- Show configuration window.
	this.ShowConfigurationWindow = function()
		applicationsManager:SetCurrentApplication(initApplication.Id);
		local configurationWindow = ConfigurationWindow(initApplication);
		configurationWindow:Show();
	end

	this.GetTopLineIndex = function()
		if (controlPanel.IsBottom) then
			return 1;
		else
			return 2;
		end
	end
end)
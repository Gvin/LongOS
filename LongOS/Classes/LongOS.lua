local ConfigurationManager = Classes.System.Configuration.ConfigurationManager;
local LocalizationManager = Classes.System.Localization.LocalizationManager;
local Logger = Classes.System.Logger;
local VideoBuffer = Classes.System.Graphics.VideoBuffer;
local ApplicationsManager = Classes.System.ApplicationsManager;
local Desktop = Classes.System.Desktop;
local ControlPanel = Classes.System.ControlPanel;

local Application = Classes.Application.Application;

local MessageWindow = Classes.System.Windows.MessageWindow;

Classes.System.LongOS = Class(Object, function(this, _systemDirectory)
	Object.init(this, 'LongOS');

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local currentVersion;

	local configurationManager;
	local runtimeLog;

	local videoBuffer;
	local applicationsManager;
	local desktopManager;
	local controlPanel;

	local initApplication;

	local working;
	local updateLock;

	local dblClickTimer;
	local clickX;
	local clickY;

	local eventsQueue;
	local allowedTimers;

	local systemDirectory;

	local locale;
	local localizationManager;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:GetWorking()
		return working;
	end

	function this:GetCurrentVersion()
		return currentVersion;
	end

	function this:GetApplicationsCount()
		return applicationsManager:GetApplicationsCount();
	end

	function this:GetApplicationsList()
		return applicationsManager:GetApplicationsList();
	end

	function this:GetColorConfiguration()
		return configurationManager:GetColorConfiguration();
	end

	function this:GetInterfaceConfiguration()
		return configurationManager:GetInterfaceConfiguration();
	end	

	function this:GetMouseConfiguration()
		return configurationManager:GetMouseConfiguration();
	end	

	function this:GetApplicationsConfiguration()
		return configurationManager:GetApplicationsConfiguration();
	end

	function this:GetFileAssotiationsConfiguration()
		return configurationManager:GetFileAssotiationsConfiguration();
	end

	function this:GetControlPanel()
		return controlPanel;
	end

	function this:GetSystemDirectory()
		return systemDirectory;
	end

	function this:GetSystemLocale()
		return locale;
	end

	function this:SetSystemLocale(_value)
		if (type(_value) ~= 'string') then
			error('LongOS.SetSystemLocale [value]: String expected, got '..type(_value)..'.');
		end

		locale = _value;
		local localizationConfiguration = configurationManager:GetLocaleConfiguration();
		localizationConfiguration:SetLocale(locale);
		localizationConfiguration:WriteConfiguration();
	end

	function this:GetLocalizedString(_key)
		return localizationManager:GetLocalizedString(_key);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:LogRuntimeError(_errorText)
		runtimeLog:LogError(_errorText);
	end

	function this:LogWarningMessage(_warningText)
		runtimeLog:LogWarning(_warningText);
	end

	function this:LogDebugMessage(_text)
		runtimeLog:LogDebug(_text);
	end

	function this:AddTimer(_timer)
		table.insert(allowedTimers, _timer);
	end

	local function removeTimer(_timer)
		local index;
		for i = 1, #allowedTimers do
			if (allowedTimers[i] == _timer) then
				index = i;
			end
		end
		if (index ~= nil) then
			table.remove(allowedTimers, index);
		end
	end

	function this:AddApplication(_application)
		applicationsManager:AddApplication(_application);
	end

	function this:RemoveApplication(_applicationId)
		applicationsManager:RemoveApplication(_applicationId);
	end

	function this:SetCurrentApplication(_applicationId)
		applicationsManager:SetCurrentApplication(_applicationId);
	end

	function this:Update()
		updateLock = true;
		applicationsManager:Update();
		updateLock = false;

		if (dblClickTimer > 0) then
			dblClickTimer = dblClickTimer - 1;
		end
	end

	function this:Draw()
		if (not updateLock) then
			videoBuffer:SetCursorBlink(false);

			desktopManager:Draw(videoBuffer);
			applicationsManager:Draw(videoBuffer);
			controlPanel:Draw(videoBuffer);

			videoBuffer:Draw();
		end
	end

	local function processDoubleClickEvent(_cursorX, _cursorY)
		applicationsManager:ProcessDoubleClickEvent(_cursorX, _cursorY);
	end

	local function processLeftClickEvent(_cursorX, _cursorY)
		local mouseConfiguration = configurationManager:GetMouseConfiguration();

		if (dblClickTimer > 0 and clickX == _cursorX and clickY == _cursorY) then
			processDoubleClickEvent(_cursorX, _cursorY);
			return;
		end

		dblClickTimer = tonumber(mouseConfiguration:GetOption('DoubleClickSpeed'));
		clickX = _cursorX;
		clickY = _cursorY;

		desktopManager:ProcessLeftClickEvent(_cursorX, _cursorY);
		if (controlPanel:ProcessLeftClickEvent(_cursorX, _cursorY)) then
			return;
		end
		applicationsManager:ProcessLeftClickEvent(_cursorX, _cursorY);
	end

	local function processRightClickEvent(_cursorX, _cursorY)
		if (applicationsManager:ProcessRightClickEvent(_cursorX, _cursorY)) then
			return;
		end

		desktopManager:ProcessRightClickEvent(_cursorX, _cursorY);
	end

	local function processMouseClickEvent(_button, _cursorX, _cursorY)
		if (_button == 1) then -- If left mouse click
			processLeftClickEvent(_cursorX, _cursorY);
		elseif (_button == 2) then -- If right mouse click
			processRightClickEvent(_cursorX, _cursorY);
		end
	end

	local function processMouseDragEvent(_button, _newCursorX, _newCursorY)
		if (_button == 1) then
			applicationsManager:ProcessLeftMouseDragEvent(_newCursorX, _newCursorY);
		elseif (_button == 2) then
			applicationsManager:ProcessRightMouseDragEvent(_newCursorX, _newCursorY);
		end
	end

	local function processTabKey()
		applicationsManager:SwitchApplication();
	end

	local function processKeys(_key)
		if (_key == keys.tab) then
			processTabKey();
		else
			applicationsManager:ProcessKeyEvent(_key);
		end
	end

	local function processCharEvent(_char)
		applicationsManager:ProcessCharEvent(_char);
	end

	local function processRednetEvent(_id, _message, _distance, _side, _channel)
		applicationsManager:ProcessRednetEvent(_id, _message, _distance, _side, _channel);
	end

	local function processTimerEvent(_timerId)
		applicationsManager:ProcessTimerEvent(_timerId);
	end

	local function processRedstoneEvent()
		applicationsManager:ProcessRedstoneEvent();
	end

	local function processMouseScrollEvent(_scrollDirection, _cursorX, _cursorY)
		applicationsManager:ProcessMouseScrollEvent(_scrollDirection, _cursorX, _cursorY);
	end

	local function processHttpEvent(_eventName, _url, _handler)
		applicationsManager:ProcessHttpEvent(_eventName == 'http_success', _url, _handler);
	end

	local function processUnknownEvent(_eventName, _params)
		applicationsManager:ProcessEvent(_eventName, _params);
	end

	function this:ProcessEvents()
		if (#eventsQueue > 0) then
			local event = eventsQueue[1];
			if (event.Name == 'mouse_click') then
				processMouseClickEvent(event.Params[1], event.Params[2], event.Params[3]);
			elseif (event.Name == 'mouse_drag') then
				processMouseDragEvent(event.Params[1], event.Params[2], event.Params[3]);
			elseif (event.Name == 'key') then
				processKeys(event.Params[1]);
			elseif (event.Name == 'char') then
				processCharEvent(event.Params[1]);
			elseif (event.Name == 'modem_message') then
				processRednetEvent(event.Params[3], event.Params[4], event.Params[5], event.Params[1], event.Params[2]);
			elseif (event.Name == 'timer') then
				processTimerEvent(event.Params[1]);
			elseif (event.Name == 'redstone') then
				processRedstoneEvent();
			elseif (event.Name == 'mouse_scroll') then
				processMouseScrollEvent(event.Params[1], event.Params[2], event.Params[3]);
			elseif (event.Name:find('http')) then
				processHttpEvent(event.Name, event.Params[1], event.Params[2]);
			else
				processUnknownEvent(event.Name, event.Params);
			end
			table.remove(eventsQueue, 1);
		else
			oldSleep(0.1);
		end
	end

	local function addEvent(_eventName, _params)
		local event = {};
		event.Name = _eventName;
		event.Params = _params;
		table.insert(eventsQueue, event);
	end

	function this:CatchEvents()
		local event, param1, param2, param3, param4, param5 = os.pullEventRaw();

		if (event == 'timer') then
			if (not tableExtAPI.contains(allowedTimers, param1)) then
				return;
			end

			removeTimer(param1);
		end

		addEvent(event, { param1, param2, param3, param4, param5 });
	end

	function this:ShowMessage(_title, _text, _textColor)
		applicationsManager:SetCurrentApplication(initApplication:GetId());
		local messageWindow = MessageWindow(initApplication, _title, _text, _textColor);
		messageWindow:Show();
	end

	function this:ShowModalMessage(_application, _title, _text, _textColor)
		applicationsManager:SetCurrentApplication(_application:GetId());
		local messageWindow = MessageWindow(_application, _title, _text, _textColor);
		messageWindow:ShowModal();
	end

	function this:ShowError(_message)
		this:ShowMessage(this:GetLocalizedString('Error.Title'), string.format(this:GetLocalizedString('Error.Text'), tostring(_message)), colors.red);
	end

	function this:GetCurrentTime()
		local nTime = os.time();
		local sTime = textutils.formatTime(nTime, true);
		if (string.len(sTime) < 5) then
			sTime = '0'..sTime;
		end

		return sTime;
	end

	local function generateIdPart()
		local selector = math.random(0, 2);
		if (selector == 1) then
			return string.char(math.random(48, 57));
		elseif (selector == 2) then
			return string.char(math.random(65, 90));
		else
			return string.char(math.random(97, 122));
		end
	end

	function this:GenerateId()
		local result = '';
		for i = 1, 20 do
			result = result..generateIdPart();
		end

		return result;
	end

	function this:Try(_func)
		local sucess, message = pcall(_func);
		if (not sucess) then
			System:LogRuntimeError('Error while trying to run function. Message:"'..tostring(message)..'".');
			this:ShowError(tostring(message));
			return false;
		end

		return true;
	end

	function this:RunFile(_filePath)
		local path = ''..string.gsub(_filePath, '%%SYSDIR%%', systemDirectory);
		local sucess = shell.run(path);
		if (not sucess) then
			System:LogRuntimeError('Error occured when running file "'..path..'".');
			this:ShowMessage(this:GetLocalizedString('Error.Title'), string.format(this:GetLocalizedString('Error.FileError.Text'), path), colors.red);
		end
	end

	function this:ResolvePath(_path)
		return ''..string.gsub(_path, '%%SYSDIR%%', systemDirectory);
	end

	function this:ReadConfiguration()
		configurationManager:ReadConfiguration();

		locale = configurationManager:GetLocaleConfiguration():GetLocale();
		localizationManager:ReadLocalization(locale);
	end

	function this:WriteConfiguration()
		configurationManager:WriteConfiguration();
	end

	function this:ReadAutoexec()
		local file = fs.open(this:ResolvePath('%SYSDIR%/Configuration/autoexec'), 'r');

		local line = file.readLine();
		while (line) do
			if (fs.exists(line)) then
				System:RunFile(line);
			end
			line = file.readLine();
		end
		file.close();
	end

	function this:Shutdown()
		os.shutdown();
	end

	function this:Reboot()
		os.reboot();
	end

	function this:LogOff()
		working = false;
	end

	function this:Initialize()
		videoBuffer = VideoBuffer();

		applicationsManager = ApplicationsManager();

		desktopManager = Desktop();
		local interfaceConfiguration = configurationManager:GetInterfaceConfiguration();
		local filename = interfaceConfiguration:GetOption('WallpaperFileName');
		local x = interfaceConfiguration:GetOption('WallpaperXShift');
		local y = interfaceConfiguration:GetOption('WallpaperYShift');
		desktopManager:LoadWallpaper(this:ResolvePath(filename), tonumber(x), tonumber(y));
		
		controlPanel = ControlPanel();
		controlPanel:RefreshApplications();

		initApplication = Application('Init', true, false);
		applicationsManager:AddApplication(initApplication);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function cleanTempDirectory()
		local tempDirPath = this:ResolvePath('/%SYSDIR%/Temp/');
		if (fs.exists(tempDirPath)) then
			fs.delete(tempDirPath);
		end
		fs.makeDir(tempDirPath);
	end

	local function constructor(_systemDirectory)
		working = true;
		updateLock = false;
		currentVersion = '1.2';
		systemDirectory = _systemDirectory;

		cleanTempDirectory();

		dblClickTimer = 0;
		clickX = 0;
		clickY = 0;

		eventsQueue = {};
		allowedTimers = {};

		configurationManager = ConfigurationManager(systemDirectory);
		localizationManager = LocalizationManager(this:ResolvePath('%SYSDIR%/Localizations'), this:ResolvePath('%SYSDIR%/Localizations/default.xml'));
		runtimeLog = Logger(this:ResolvePath('%SYSDIR%/Logs/runtime.log'));
	end

	constructor(_systemDirectory);
end)
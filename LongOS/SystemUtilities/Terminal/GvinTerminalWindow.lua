local Window = Classes.Application.Window;
local Thread = Classes.Application.Thread;
local ThreadsManager = Classes.Application.ThreadsManager;

local Button = Classes.Components.Button;

local LocalizationManager = Classes.System.Localization.LocalizationManager;

GvinTerminalWindow = Class(Window, function(this, _application, _fileName)
	Window.init(this, _application, 'Gvin terminal', false);
	this:SetWidth(40);
	this:SetHeight(13);
	this:SetMinimalWidth(26);
	this:SetMinimalHeight(6)

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local redirector;
	local threadsManager;
	local paused;
	local executing;

	local terminateButton;
	local pauseResumeButton;
	local restartButton;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function update()
		if (not paused) then
			term.redirect(redirector);
			threadsManager:Update();
			term.restore();
		end
	end

	function this:Update()
		update();
	end

	function this:Draw(_videoBuffer)
		local canvas = redirector.canvas;
		canvas:Draw(_videoBuffer, 0, 1, _videoBuffer:GetWidth() - 2, _videoBuffer:GetHeight() - 3);
	end

	function this:ProcessCharEvent(_char)
		if (not paused) then
			threadsManager:ProcessCharEvent(_char);
		end
		update();
	end

	function this:ProcessKeyEvent(_key)
		if (not paused) then
			threadsManager:ProcessKeyEvent(_key);
		end
		update();
	end

	function this:ProcessTimerEvent(_timerId)
		threadsManager:ProcessTimerEvent(_timerId);
		update();
	end

	function this:ProcessRednetEvent(_id, _message, _distance, _side, _channel)
		threadsManager:ProcessRednetEvent(_id, _message, _distance, _side, _channel);
		update();
	end

	function this:ProcessLeftClickEvent(_cursorX, _cursorY)
		if (not paused) then
			local cursorX = _cursorX - this:GetX();
			local cursorY = _cursorY - this:GetY() - 1;
			threadsManager:ProcessLeftClickEvent(cursorX, cursorY);
		end
		update();
	end

	function this:ProcessRightClickEvent(_cursorX, _cursorY)
		if (not paused) then
			local cursorX = _cursorX - this:GetX();
			local cursorY = _cursorY - this:GetY() - 1;
			threadsManager:ProcessRightClickEvent(cursorX, cursorY);
		end
		update();
	end


	function this:ProcessDoubleClickEvent(_cursorX, _cursorY)
		if (not paused) then
			local cursorX = _cursorX - this:GetX();
			local cursorY = _cursorY - this:GetY() - 1;
			threadsManager:ProcessLeftClickEvent(cursorX, cursorY);
		end
		update();
	end

	function this:ProcessLeftMouseDragEvent(_newCursorX, _newCursorY)
		if (not paused) then
			local cursorX = _newCursorX - this:GetX();
			local cursorY = _newCursorY - this:GetY() - 1;
			threadsManager:ProcessLeftMouseDragEvent(cursorX, cursorY);
		end
		update();
	end

	function this:ProcessRightMouseDragEvent(_newCursorX, _newCursorY)
		if (not paused) then
			local cursorX = _newCursorX - this:GetX();
			local cursorY = _newCursorY - this:GetY() - 1;
			threadsManager:ProcessRightMouseDragEvent(cursorX, cursorY);
		end
		update();
	end

	function this:ProcessMouseScrollEvent(_direction, _cursorX, _cursorY)
		if (not paused) then
			local cursorX = _cursorX - this:GetX();
			local cursorY = _cursorY - this:GetY() - 1;
			threadsManager:ProcessMouseScrollEvent(_direction, cursorX, cursorY);
		end
		update();
	end

	function this:ProcessRedstoneEvent()
		threadsManager:ProcessRedstoneEvent();
		update();
	end

	function this:ProcessHttpEvent(_status, _url, _handler)
		threadsManager:ProcessHttpEvent(_status, _url, _handler);
		update();
	end

	function this:ProcessEvent(_eventName, _params)
		threadsManager:ProcessEvent(_eventName, _params);
		update();
	end

	local function windowOnResize(_sender, _eventArgs)
		redirector.canvas:SetWidth(this:GetWidth() - 2);
		redirector.canvas:SetHeight(this:GetHeight() - 3);
	end

	local function terminateButtonClick(_sender, _eventArgs)
		if (executing) then
			threadsManager:ProcessTerminateEvent();
			update();
		end
	end

	local function pauseResumeButtonClick(_sender, _eventArgs)
		paused = not paused;
		if (paused) then
			pauseResumeButton:SetText(localizationManager:GetLocalizedString('Buttons.Resume'));
		else
			pauseResumeButton:SetText(localizationManager:GetLocalizedString('Buttons.Pause'));
		end
	end

	local function start()
		executing = true;
		
		term.setTextColor(colors.lime);
		print('LongOS terminal emulator v1.0');
		term.setTextColor(colors.white);
		
		if (_fileName ~= nil and type(_fileName) == 'string') then
			shell.run(_fileName);
		else
			shell.run('shell');
		end

		executing = false;
		os.sleep(1);
		term.setBackgroundColor(colors.black);
		term.clear();
		term.setCursorPos(1, 2);
		term.setTextColor(colors.lime);
		print('Executing finished. Closing terminal.');
		os.sleep(3);
		this:Close();
	end

	local function restartButtonClick(_sender, _eventArgs)
		threadsManager:Clear();

		redirector.setBackgroundColor(colors.black);
		redirector.clear();
		redirector.setCursorPos(1, 1);

		local thread = Thread(this:GetApplication(), start);
		threadsManager:AddThread(thread);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		terminateButton = Button(localizationManager:GetLocalizedString('Buttons.Terminate'), nil, nil, 0, 0, 'left-top');
		terminateButton:AddOnClickEventHandler(terminateButtonClick);
		this:AddComponent(terminateButton);

		pauseResumeButton = Button(localizationManager:GetLocalizedString('Buttons.Pause'), nil, nil, terminateButton:GetText():len() + 1, 0, 'left-top');
		pauseResumeButton:AddOnClickEventHandler(pauseResumeButtonClick);
		this:AddComponent(pauseResumeButton);

		restartButton = Button(localizationManager:GetLocalizedString('Buttons.Restart'), nil, nil, terminateButton:GetText():len() + pauseResumeButton:GetText():len() + 2, 0, 'left-top');
		restartButton:AddOnClickEventHandler(restartButtonClick);
		this:AddComponent(restartButton);
	end

	local function constructor(_fileName)
		paused = false;
		executing = true;
		redirector = RedirectorGenerator():GenerateRedirector(this:GetWidth() - 2, this:GetHeight() - 3);
		this:AddOnResizeEventHandler(windowOnResize);

		threadsManager = ThreadsManager();
		
		local thread = Thread(this:GetApplication(), start);
		threadsManager:AddThread(thread);

		localizationManager = LocalizationManager(fs.combine(this:GetApplication():GetWorkingDirectory(), 'Localizations'), fs.combine(this:GetApplication():GetWorkingDirectory(), 'Localizations/default.xml'));
		localizationManager:ReadLocalization(System:GetSystemLocale());

		if (_fileName ~= nil and type(_fileName) == 'string') then
			this:SetTitle(localizationManager:GetLocalizedString('Title')..' - '.._fileName);
		else
			this:SetTitle(localizationManager:GetLocalizedString('Title'));
		end

		initializeComponents(_fileName);
	end

	constructor();
end)
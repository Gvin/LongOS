local Window = Classes.Application.Window;
local Thread = Classes.Application.Thread;
local ThreadsManager = Classes.Application.ThreadsManager;

local Button = Classes.Components.Button;


GvinTerminalWindow = Class(Window, function(this, _application, _fileName)
	Window.init(this, _application, 'Gvin terminal', false);
	this:SetX(5);
	this:SetY(3);
	this:SetWidth(40);
	this:SetHeight(13);
	if (_fileName ~= nil and type(_fileName) == 'string') then
		this:SetTitle('LongOS terminal - '.._fileName);
	else
		this:SetTitle('LongOS terminal');
	end
	this:SetMinimalWidth(26);
	this:SetMinimalHeight(6)

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local redirector;
	local threadsManager;
	local paused;

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

	function this.Update()
		update();
	end

	function this.Draw(_, _videoBuffer)
		local canvas = redirector.canvas;
		canvas:Draw(_videoBuffer, 0, 1, _videoBuffer:GetWidth() - 2, _videoBuffer:GetHeight() - 3);
	end

	function this.ProcessCharEvent(_, _char)
		if (not paused) then
			threadsManager:ProcessCharEvent(_char);
		end
		update();
	end

	function this.ProcessKeyEvent(_, _key)
		if (not paused) then
			threadsManager:ProcessKeyEvent(_key);
		end
		update();
	end

	function this.ProcessTimerEvent(_, _timerId)
		threadsManager:ProcessTimerEvent(_timerId);
		update();
	end

	function this.ProcessRednetEvent(_, _id, _message, _distance)
		if (not paused) then
			threadsManager:ProcessRednetEvent(_id, _message, _distance);
		end
		update();
	end

	function this.ProcessLeftClickEvent(_, _cursorX, _cursorY)
		if (not paused) then
			local cursorX = _cursorX - this:GetX();
			local cursorY = _cursorY - this:GetY() - 1;
			threadsManager:ProcessLeftClickEvent(cursorX, cursorY);
		end
		update();
	end

	function this.ProcessRightClickEvent(_, _cursorX, _cursorY)
		if (not paused) then
			local cursorX = _cursorX - this:GetX();
			local cursorY = _cursorY - this:GetY() - 1;
			threadsManager:ProcessRightClickEvent(cursorX, cursorY);
		end
		update();
	end

	function this.ProcessLeftMouseDragEvent(_, _newCursorX, _newCursorY)
		if (not paused) then
			local cursorX = _newCursorX - this:GetX();
			local cursorY = _newCursorY - this:GetY() - 1;
			threadsManager:ProcessLeftMouseDragEvent(cursorX, cursorY);
		end
		update();
	end

	function this.ProcessRightMouseDragEvent(_, _newCursorX, _newCursorY)
		if (not paused) then
			local cursorX = _newCursorX - this:GetX();
			local cursorY = _newCursorY - this:GetY() - 1;
			threadsManager:ProcessRightMouseDragEvent(cursorX, cursorY);
		end
		update();
	end

	function this.ProcessMouseScrollEvent(_, _direction, _cursorX, _cursorY)
		if (not paused) then
			local cursorX = _cursorX - this:GetX();
			local cursorY = _cursorY - this:GetY() - 1;
			threadsManager:ProcessMouseScrollEvent(_direction, cursorX, cursorY);
		end
		update();
	end

	function this.ProcessRedstoneEvent()
		if (not paused) then
			threadsManager:ProcessRedstoneEvent();
		end
		update();
	end

	local function windowOnResize(_sender, _eventArgs)
		redirector.canvas:SetWidth(this:GetWidth() - 2);
		redirector.canvas:SetHeight(this:GetHeight() - 3);
	end

	local function terminateButtonClick(_sender, _eventArgs)
		threadsManager:ProcessTerminateEvent();
		update();
	end

	local function pauseResumeButtonClick(_sender, _eventArgs)
		paused = not paused;
		if (paused) then
			pauseResumeButton:SetText('Resume');
		else
			pauseResumeButton:SetText('Pause ');
		end
	end

	local function start()
		if (_fileName ~= nil and type(_fileName) == 'string') then
			shell.run(_fileName);
		else
			shell.run('shell');
		end

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
		terminateButton = Button('Terminate', nil, nil, 0, 0, 'left-top');
		terminateButton:SetOnClick(terminateButtonClick);
		this:AddComponent(terminateButton);

		pauseResumeButton = Button('Pause ', nil, nil, 10, 0, 'left-top');
		pauseResumeButton:SetOnClick(pauseResumeButtonClick);
		this:AddComponent(pauseResumeButton);

		restartButton = Button('Restart', nil, nil, 17, 0, 'left-top');
		restartButton:SetOnClick(restartButtonClick);
		this:AddComponent(restartButton);
	end

	local function constructor()
		paused = false;
		redirector = RedirectorGenerator():GenerateRedirector(this:GetWidth() - 2, this:GetHeight() - 3);
		this:SetOnResize(windowOnResize);

		threadsManager = ThreadsManager();
		
		local thread = Thread(this:GetApplication(), start);
		threadsManager:AddThread(thread);

		initializeComponents();
	end

	constructor();
end)
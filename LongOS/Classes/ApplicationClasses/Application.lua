-- Application class. Represents all applications in the system.
-- Serves as a container for windows and threads. May be a daemon process if shutdownWhenNoWindows property is setted to true.
Application = Class(Object, function(this, _applicationName, _isUnique, _shutdownWhenNoWindows)
	Object.init(this, 'Application');

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local id;
	local name;
	local isUnique;
	local shutdownWhenNoWindows;

	local enabled;
	
	local windowsManager;
	local threadsManager;
	

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:GetName()
		return name;
	end

	function this:GetIsUnique()
		return isUnique;
	end

	function this:GetEnabled()
		return enabled;
	end

	function this:SetEnabled(_value)
		if (type(_value) ~= 'boolean') then
			error('Application.SetEnabled [value]: Boolean expected, got '..type(_value)..'.');
		end

		enabled = _value;
	end

	function this:GetId()
		return id;
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:Initialize(_id)
		if (type(_id) ~= 'string') then
			error('Application.Initialize [id]: String expected, got '..type(_id)..'.');
		end

		id = _id;
	end

	function this:AddWindow(_window)
		windowsManager:AddWindow(_window);
	end

	function this:RemoveWindow(_windowId)
		windowsManager:RemoveWindow(_windowId);
	end

	function this:AddThread(_thread)
		threadsManager:AddThread(_thread);
	end

	function this:RemoveThread(_id)
		threadsManager:RemoveThread(_id);
	end

	function this:Clear()
		threadsManager:Clear();
		windowsManager:Clear();
	end

	function this:Contains(_x, _y)
		return windowsManager:Contains(_x, _y);
	end

	function this:GetWindowsCount()
		return windowsManager:GetWindowsCount();
	end

	function this:Run(_window)
		if (_window == nil and shutdownWhenNoWindows) then 
			return;
		end
		if (_window == nil) then
			return;
		end
		windowsManager:AddWindow(_window);
		System:AddApplication(this);
	end

	function this:Draw(_videoBuffer)
		windowsManager.Enabled = enabled;
		windowsManager:Draw(_videoBuffer);
	end

	function this:Update()
		windowsManager:Update();
		threadsManager:Update();

		if (shutdownWhenNoWindows and windowsManager:GetWindowsCount() == 0) then
			this:Close();
		end
	end

	function this:Close()
		System:RemoveApplication(id);
	end

	function this:ProcessKeyEvent(_key)
		windowsManager:ProcessKeyEvent(_key);
		threadsManager:ProcessKeyEvent(_key);
	end

	function this:ProcessCharEvent(_char)
		windowsManager:ProcessCharEvent(_char);
		threadsManager:ProcessCharEvent(_char);
	end

	function this:ProcessRednetEvent(_id, _message, _distance, _side, _channel)
		windowsManager:ProcessRednetEvent(_id, _message, _distance, _side, _channel);
		threadsManager:ProcessRednetEvent(_id, _message, _distance, _side, _channel);
	end

	function this:ProcessLeftClickEvent(_cursorX, _cursorY)
		threadsManager:ProcessLeftClickEvent(_cursorX, _cursorY);
		return windowsManager:ProcessLeftClickEvent(_cursorX, _cursorY);
	end

	function this:ResetDragging()
		windowsManager:ResetDragging();
	end

	function this:ProcessRightClickEvent(_cursorX, _cursorY)
		threadsManager:ProcessRightClickEvent(_cursorX, _cursorY);
		return windowsManager:ProcessRightClickEvent(_cursorX, _cursorY);
	end

	function this:ProcessDoubleClickEvent(_cursorX, _cursorY)
		windowsManager:ProcessDoubleClickEvent(_cursorX, _cursorY);
	end

	function this:ProcessLeftMouseDragEvent(_newCursorX, _newCursorY)
		windowsManager:ProcessLeftMouseDragEvent(_newCursorX, _newCursorY);
		threadsManager:ProcessLeftMouseDragEvent(_newCursorX, _newCursorY);
	end

	function this:ProcessRightMouseDragEvent(_newCursorX, _newCursorY)
		windowsManager:ProcessRightMouseDragEvent(_newCursorX, _newCursorY);
		threadsManager:ProcessRightMouseDragEvent(_newCursorX, _newCursorY);
	end

	function this:ProcessTimerEvent(_timerId)
		threadsManager:ProcessTimerEvent(_timerId);
		windowsManager:ProcessTimerEvent(_timerId);
	end

	function this:ProcessRedstoneEvent()
		threadsManager:ProcessRedstoneEvent();
		windowsManager:ProcessRedstoneEvent();
	end

	function this:ProcessMouseScrollEvent(_direction, _cursorX, _cursorY)
		threadsManager:ProcessMouseScrollEvent(_direction, _cursorX, _cursorY);
		windowsManager:ProcessMouseScrollEvent(_direction, _cursorX, _cursorY);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor1(_applicationName, _isUnique, _shutdownWhenNoWindows)
		if (type(_applicationName) ~= 'string') then
			error('Application.Constructor [applicationName]: String expected, got '..type(_applicationName)..'.');
		end
		if (type(_isUnique) ~= 'boolean') then
			error('Application.Constructor [isUnique]: Boolean expected, got '..type(_isUnique)..'.');
		end
		if (type(_shutdownWhenNoWindows) ~= 'boolean') then
			error('Application.Constructor [shutdownWhenNoWindows]: Boolean expected, got '..type(_shutdownWhenNoWindows)..'.');
		end

		name = _applicationName;
		isUnique = _isUnique;
		shutdownWhenNoWindows = _shutdownWhenNoWindows;

		enabled = true;

		windowsManager = Classes.Application.WindowsManager();
		threadsManager = Classes.Application.ThreadsManager();
	end

	local function constructor2(_applicationName, _isUnique)
		constructor1(_applicationName, _isUnique, true);
	end

	local function constructor3(_applicationName)
		constructor2(_applicationName, false);
	end

	if (_shutdownWhenNoWindows == nil and _isUnique == nil) then
		constructor3(_applicationName);
	elseif (_isUnique ~= nil and _shutdownWhenNoWindows == nil) then
		constructor2(_applicationName, _isUnique);
	elseif (_isUnique ~= nil and _shutdownWhenNoWindows ~= nil) then
		constructor1(_applicationName, _isUnique, _shutdownWhenNoWindows);
	else
		error('Application.Constructor: Not found constructor with such parameters.');
	end
end)
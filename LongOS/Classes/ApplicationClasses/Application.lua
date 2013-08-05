Application = Class(function(this, _applicationName, _isUnique, _shutdownWhenNoWindows)
	
	this.GetClassName = function()
		return 'Application';
	end

	----- Fields -----

	local name;
	local isUnique;
	local enabled;
	local id;
	local windowsManager;
	local shutdownWhenNoWindows;

	----- Properties -----

	this.GetName = function()
		return name;
	end

	this.GetIsUnique = function()
		return isUnique;
	end

	this.GetEnabled = function()
		return enabled;
	end

	this.SetEnabled = function(_, _value)
		enabled = _value;
	end

	this.GetId = function()
		return id;
	end

	this.SetId = function(_, _value)
		id = _value;
	end

	----- Methods -----

	this.AddWindow = function(_, _window)
		windowsManager:AddWindow(_window);
	end

	this.DeleteWindow = function(_, _windowId)
		windowsManager:DeleteWindow(_windowId);
	end

	this.Run = function(_, _window)
		if (_window == nil and shutdownWhenNoWindows) then 
			return;
		end
		if (_window == nil) then
			return;
		end
		windowsManager:AddWindow(_window);
		System:AddApplication(this);
	end

	this.Draw = function(_, _videoBuffer)
		windowsManager.Enabled = enabled;
		windowsManager:Draw(_videoBuffer);
	end

	this.Update = function(_)
		windowsManager:Update();

		if (shutdownWhenNoWindows and windowsManager:GetWindowsCount() == 0) then
			this:Close();
		end
	end

	this.Close = function(_)
		System:DeleteApplication(id);
	end

	this.ProcessKeyEvent = function(_, _key)
		windowsManager:ProcessKeyEvent(_key);
	end

	this.ProcessCharEvent = function(_, _char)
		windowsManager:ProcessCharEvent(_char);
	end

	this.ProcessRednetEvent = function(_, _id, _message, _distance)
		windowsManager:ProcessRednetEvent(_id, _message, _distance);
	end

	this.ProcessLeftClickEvent = function(_, _cursorX, _cursorY)
		return windowsManager:ProcessLeftClickEvent(_cursorX, _cursorY);
	end

	this.ResetMoving = function()
		windowsManager:ResetMoving();
	end

	this.ProcessRightClickEvent = function(_, _cursorX, _cursorY)
		return windowsManager:ProcessRightClickEvent(_cursorX, _cursorY);
	end

	this.ProcessDoubleClickEvent = function(_, _cursorX, _cursorY)
		windowsManager:ProcessDoubleClickEvent(_cursorX, _cursorY);
	end

	this.ProcessLeftMouseDragEvent = function(_, _newCursorX, _newCursorY)
		windowsManager:ProcessLeftMouseDragEvent(_newCursorX, _newCursorY);
	end

	this.ProcessRightMouseDragEvent = function(_, _newCursorX, _newCursorY)
		windowsManager:ProcessRightMouseDragEvent(_newCursorX, _newCursorY);
	end

	this.Contains = function(_, _x, _y)
		return windowsManager:Contains(_x, _y);
	end

	this.GetWindowsCount = function(_)
		return windowsManager:GetWindowsCount();
	end

	----- Constructors -----

	local constructor1 = function(_applicationName, _isUnique, _shutdownWhenNoWindows)
		name = _applicationName;
		isUnique = _isUnique;
		shutdownWhenNoWindows = _shutdownWhenNoWindows;

		enabled = true;

		windowsManager = WindowsManager();
	end

	local constructor2 = function(_applicationName, _isUnique)
		constructor1(_applicationName, _isUnique, true);
	end

	local constructor3 = function(_applicationName)
		constructor2(_applicationName, false);
	end

	if (type(_applicationName) ~= 'string') then
		error('Application.Constructor [applicationName]: String expected, got '..type(_applicationName)..'.');
	end

	if (_shutdownWhenNoWindows == nil and _isUnique == nil) then
		constructor3(_applicationName);
	elseif (_isUnique ~= nil and _shutdownWhenNoWindows == nil) then
		if (type(_isUnique) ~= 'boolean') then
			error('Application.Constructor [isUnique]: Boolean expected, got '..type(_isUnique)..'.');
		end

		constructor2(_applicationName, _isUnique);
	elseif (_isUnique ~= nil and _shutdownWhenNoWindows ~= nil) then
		if (type(_isUnique) ~= 'boolean') then
			error('Application.Constructor [isUnique]: Boolean expected, got '..type(_isUnique)..'.');
		end
		if (type(_shutdownWhenNoWindows) ~= 'boolean') then
			error('Application.Constructor [shutdownWhenNoWindows]: Boolean expected, got '..type(_shutdownWhenNoWindows)..'.');
		end

		constructor1(_applicationName, _isUnique, _shutdownWhenNoWindows);
	else
		error('Application.Constructor: Not found constructor with such parameters.');
	end
end)
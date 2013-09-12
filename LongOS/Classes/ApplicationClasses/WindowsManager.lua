Classes.Application.WindowsManager = Class(Object, function(this)
	Object.init(this, 'WindowsManager');

	this.Enabled = true;
	local windows = {};
	local currentWindow = nil;

	this.GetWindowsCount = function(_)
		return #windows;
	end

	local getWindowById = function(windowId)
		for i = 1, #windows do
			if (windows[i]:GetId() == windowId) then
				return windows[i], i;
			end
		end
		return nil, nil;
	end

	local getWindowByName = function(windowName)
		for i = 1, #windows do
			if (windows[i]:GetName() == windowName) then
				return windows[i], i;
			end
		end
		return nil, nil;
	end

	this.AddWindow = function(_, window)
		if (window:GetIsUnique()) then
			local oldWindow, index = getWindowByName(window:GetName());
			if (oldWindow ~= nil and (currentWindow == nil or not currentWindow:GetIsModal())) then
				currentWindow = oldWindow;
				return;
			end
		end
		window:SetId(System:GenerateId());
		table.insert(windows, window);
		currentWindow = window;
	end

	this.SetCurrentWindow = function(_, windowId)
		local windowToSet = getWindowById(windowId);
		currentWindow = windowToSet;
	end

	local function getNextWindow(_deletingIndex)
		if (windows[_deletingIndex - 1] ~= nil) then
			return windows[_deletingIndex - 1];
		end

		local index = _deletingIndex - 1;
		while (index >= 1 and windows[index] == nil) do
			index = index - 1;
		end
		return windows[index];
	end

	this.RemoveWindow = function(_, windowId)
		local windowToDelete, indexToDelete = getWindowById(windowId);
		if (indexToDelete ~= nil) then
			table.remove(windows, indexToDelete);
			if (currentWindow == windowToDelete) then
				currentWindow = nil;
				currentWindow = getNextWindow(indexToDelete);
			end
		end
	end

	this.Clear = function()
		windows = {};
		currentWindow = nil;
	end

	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		if (currentWindow ~= nil) then
			if (currentWindow:Contains(cursorX, cursorY)) then
				currentWindow:ProcessLeftClickEventBase(cursorX, cursorY);
			else
				if (not currentWindow:GetIsModal()) then
					for i = 1, #windows do
						if (windows[i]:Contains(cursorX, cursorY)) then
							currentWindow = windows[i];
							return;
						end
					end
				end
			end
		end
	end

	this.ResetDragging = function()
		for i = 1, #windows do
			windows[i]:ResetDragging();
		end
	end

	this.ProcessRightClickEvent = function(_, cursorX, cursorY)
		if (currentWindow ~= nil) then
			return currentWindow:ProcessRightClickEventBase(cursorX, cursorY);
		end
	end

	this.ProcessDoubleClickEvent = function(_, cursorX, cursorY)
		if (currentWindow ~= nil) then
			currentWindow:ProcessDoubleClickEventBase(cursorX, cursorY);
		end
	end

	this.ProcessLeftMouseDragEvent = function(_, newCursorX, newCursorY)
		if (currentWindow ~= nil) then
			currentWindow:ProcessLeftMouseDragEventBase(newCursorX, newCursorY);
		end
	end

	this.ProcessRightMouseDragEvent = function(_, newCursorX, newCursorY)
		if (currentWindow ~= nil) then
			currentWindow:ProcessRightMouseDragEventBase(newCursorX, newCursorY);
		end
	end

	this.ProcessMouseScrollEvent = function(_, direction, cursorX, cursorY)
		if (currentWindow ~= nil) then
			currentWindow:ProcessMouseScrollEventBase(direction, cursorX, cursorY);
		end
	end

	this.ProcessKeyEvent = function(_, key)
		if (currentWindow ~= nil) then
			currentWindow:ProcessKeyEventBase(key);
		end
	end

	this.ProcessCharEvent = function(_, char)
		if (currentWindow ~= nil) then
			currentWindow:ProcessCharEventBase(char);
		end
	end

	this.ProcessRednetEvent = function(_, id, message, distance, side, channel)
		for i = 1, #windows do
			windows[i]:ProcessRednetEventBase(id, message, distance, side, channel);
		end
	end

	this.ProcessRedstoneEvent = function()
		for i = 1, #windows do
			windows[i]:ProcessRedstoneEvent();
		end
	end

	this.ProcessTimerEvent = function(_, _timerId)
		for i = 1, #windows do
			windows[i]:ProcessTimerEventBase(_timerId);
		end
	end

	this.ProcessHttpEvent = function(_, _status, _url, _handler)
		for i = 1, #windows do
			windows[i]:ProcessHttpEventBase(_status, _url, _handler);
		end
	end

	this.SwitchWindow = function(_)
		if (currentWindow ~= nil) then
			local window, index = getWindowById(currentWindow:GetId());
			index = index + 1;
			if (index > #windows) then
				index = 1;
			end

			currentWindow = windows[index];
		end
	end

	this.Contains = function(_, x, y)
		for i = 1, #windows do
			if (windows[i]:Contains(x, y)) then
				return true;
			end
		end

		return false;
	end

	this.Draw = function(_, videoBuffer)
		for i = 1, #windows do
			if (windows[i] ~= nil) then
				windows[i]:SetEnabled(false);
				windows[i]:DrawBase(videoBuffer);
			end
		end
		if (currentWindow ~= nil) then
			currentWindow:SetEnabled(this.Enabled);
			currentWindow:DrawBase(videoBuffer);
		end
	end

	this.Update = function(_)
		if (currentWindow ~= nil and currentWindow:GetIsModal()) then
			currentWindow:UpdateBase();
		else
			for i = 1, #windows do
				windows[i]:UpdateBase();
			end
		end
	end
end)
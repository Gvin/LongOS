WindowsManager = Class(function(this)

	this.GetClassName = function()
		return 'WindowsManager';
	end

	this.Enabled = true;
	local windows = {};
	local currentWindow = nil;

	this.GetWindowsCount = function(_)
		return #windows;
	end

	local getWindowById = function(windowId)
		for i = 1, #windows do
			if (windows[i].Id == windowId) then
				return windows[i], i;
			end
		end
		return nil, nil;
	end

	local getWindowByName = function(windowName)
		for i = 1, #windows do
			if (windows[i].Name == windowName) then
				return windows[i], i;
			end
		end
		return nil, nil;
	end

	this.AddWindow = function(_, window)
		if (window.IsUnique) then
			local oldWindow, index = getWindowByName(window.Name);
			if (oldWindow ~= nil) then
				currentWindow = oldWindow;
				return;
			end
		end
		window.Id = System:GenerateId();
		table.insert(windows, window);
		currentWindow = window;
	end

	this.SetCurrentWindow = function(_, windowId)
		local windowToSet = getWindowById(windowId);
		currentWindow = windowToSet;
	end

	this.DeleteWindow = function(_, windowId)
		local windowToDelete, indexToDelete = getWindowById(windowId);
		if (indexToDelete ~= nil) then
			table.remove(windows, indexToDelete);
			if (currentWindow == windowToDelete) then
				currentWindow = nil;
				currentWindow = windows[1];
			end
		end
	end

	local getString = function(variable)
		if (variable == nil) then
			return 'nil';
		elseif (type(variable) == 'table') then
			return 'table';
		elseif (type(variable) == 'function') then
			return 'function';
		end
		return ''..variable;
	end

	local windowErrorCheck = function(window, success, errorText, message)
		if (not success) then
			System:ShowError(errorText..message);
			this:DeleteWindow(window.Id);
		end
	end

	local tryProcessLeftClickEvent = function(window, cursorX, cursorY)
		local success, message = pcall(window.ProcessLeftClickEventBase, nil, cursorX, cursorY);
		if (not success) then
			System:LogRuntimeError('Left click processing error (WindowName:"'..getString(window.Name)..'", WindowId:'..getString(window.Id)..', cursorX:'..getString(cursorX)..', cursorY:'..getString(cursorY)..'). Message:"'..message..'".');
		end
		windowErrorCheck(window, success, 'Left click processing error: ', message);
	end

	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		if (currentWindow ~= nil) then
			if (currentWindow:Contains(cursorX, cursorY)) then
				tryProcessLeftClickEvent(currentWindow, cursorX, cursorY);
			else
				if (not currentWindow.IsModal) then
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

	local tryProcessRightClickEvent = function(window, cursorX, cursorY)
		local success, message = pcall(window.ProcessRightClickEventBase, nil, cursorX, cursorY);
		if (not success) then
			System:LogRuntimeError('Right click processing error (WindowName:"'..getString(window.Name)..'", WindowId:'..getString(window.Id)..', cursorX:'..getString(cursorX)..', cursorY:'..getString(cursorY)..'). Message:"'..message..'".');
		end
		windowErrorCheck(window, success, 'Right click processing error: ', message);
		if (success) then
			return message;
		end
	end

	this.ProcessRightClickEvent = function(_, cursorX, cursorY)
		if (currentWindow ~= nil) then
			return tryProcessRightClickEvent(currentWindow, cursorX, cursorY);
		end
	end

	local tryProcessDoubleClickEvent = function(window, cursorX, cursorY)
		local success, message = pcall(window.ProcessDoubleClickEventBase, nil, cursorX, cursorY);
		if (not success) then
			System:LogRuntimeError('Double click processing error (WindowName:"'..getString(window.Name)..'", WindowId:'..getString(window.Id)..', cursorX:'..getString(cursorX)..', cursorY:'..getString(cursorY)..'). Message:"'..message..'".');
		end
		windowErrorCheck(window, success, 'Double click processing error: ', message);
	end

	this.ProcessDoubleClickEvent = function(_, cursorX, cursorY)
		if (currentWindow ~= nil) then
			tryProcessDoubleClickEvent(currentWindow, cursorX, cursorY);
		end
	end

	local tryProcessKeyEvent = function(window, key)
		local success, message = pcall(window.ProcessKeyEventBase, nil, key);
		if (not success) then
			System:LogRuntimeError('Key processing error (WindowName:"'..getString(window.Name)..'", WindowId:'..getString(window.Id)..', key:'..getString(key)..'). Message:"'..message..'".');
		end
		windowErrorCheck(window, success, 'Key processing error: ', message);
	end

	this.ProcessKeyEvent = function(_, key)
		if (currentWindow ~= nil) then
			tryProcessKeyEvent(currentWindow, key);
		end
	end

	local tryProcessCharEvent = function(window, char)
		local success, message = pcall(window.ProcessCharEventBase, nil, char);
		if (not success) then
			System:LogRuntimeError('Char processing error (WindowName:"'..getString(window.Name)..'", WindowId:'..getString(window.Id)..', char:"'..getString(char)..'"). Message:"'..message..'".');
		end
		windowErrorCheck(window, success, 'Char processing error: ', message);
	end

	this.ProcessCharEvent = function(_, char)
		if (currentWindow ~= nil) then
			tryProcessCharEvent(currentWindow, char);
		end
	end

	local tryProcessRednetEvent = function(window, id, data, distance)
		local success, message = pcall(window.ProcessRednetEventBase, nil, id, data, distance);
		if (not success) then
			System:LogRuntimeError('Rednet processing error (WindowName:"'..getString(window.Name)..'", WindowId:'..getString(window.Id)..', id:'..getString(id)..', data:"'..getString(data)..'"", distance:'..getString(distance)..'). Message:"'..message..'".');
		end
		windowErrorCheck(window, success, 'Rednet processing error: ', message);
	end

	this.ProcessRednetEvent = function(_, id, message, distance)
		for i = 1, #windows do
			tryProcessRednetEvent(windows[i], id, message, distance);
		end
	end

	this.SwitchWindow = function(_)
		if (currentWindow ~= nil) then
			local window, index = getWindowById(currentWindow.Id);
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

	local tryDraw = function(window, videoBuffer)
		local success, message = pcall(window.DrawBase, nil, videoBuffer);
		if (not success) then
			System:LogRuntimeError('Drawing error (WindowName:"'..getString(window.Name)..'", WindowId:'..getString(window.Id)..'). Message:"'..message..'".');
		end
		windowErrorCheck(window, success, 'Drawing error: ', message);
	end

	this.Draw = function(_, videoBuffer)
		for i = 1, #windows do
			if (windows[i] ~= nil) then
				windows[i].Enabled = false;
				tryDraw(windows[i], videoBuffer);
			end
		end
		if (currentWindow ~= nil) then
			currentWindow.Enabled = this.Enabled;
			tryDraw(currentWindow, videoBuffer);
		end
	end

	local tryUpdate = function(window)
		local success, message = pcall(window.UpdateBase, nil, videoBuffer);
		if (not success) then
			System:LogRuntimeError('Updating error (WindowName:"'..getString(window.Name)..'", WindowId:'..getString(window.Id)..'). Message:"'..message..'".');
		end
		windowErrorCheck(window, success, 'Updating error: ', message);
	end

	this.Update = function(_)
		for i = 1, #windows do
			tryUpdate(windows[i]);
		end
	end
end)
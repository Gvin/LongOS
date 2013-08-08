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
			if (oldWindow ~= nil) then
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


	this.DeleteWindow = function(_, windowId)
		local windowToDelete, indexToDelete = getWindowById(windowId);
		if (indexToDelete ~= nil) then
			table.remove(windows, indexToDelete);
			if (currentWindow == windowToDelete) then
				currentWindow = nil;
				currentWindow = windows[indexToDelete - 1];
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
			local errorWindow = MessageWindow(window:GetApplication(), 'Error', 'Error message: '..errorText..message, colors.red);
			errorWindow:Show();
			this:DeleteWindow(window:GetId());
		end
	end

	local tryProcessLeftClickEvent = function(window, cursorX, cursorY)
		local success, message = pcall(window.ProcessLeftClickEventBase, nil, cursorX, cursorY);
		if (not success) then
			System:LogRuntimeError('Left click processing error (WindowName:"'..getString(window:GetName())..'", WindowId:'..getString(window:GetId())..', cursorX:'..getString(cursorX)..', cursorY:'..getString(cursorY)..'). Message:"'..message..'".');
		end
		windowErrorCheck(window, success, 'Left click processing error: ', message);
	end

	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		if (currentWindow ~= nil) then
			if (currentWindow:Contains(cursorX, cursorY)) then
				tryProcessLeftClickEvent(currentWindow, cursorX, cursorY);
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


	local tryProcessRightClickEvent = function(window, cursorX, cursorY)
		local success, message = pcall(window.ProcessRightClickEventBase, nil, cursorX, cursorY);
		if (not success) then
			System:LogRuntimeError('Right click processing error (WindowName:"'..getString(window:GetName())..'", WindowId:'..getString(window:GetId())..', cursorX:'..getString(cursorX)..', cursorY:'..getString(cursorY)..'). Message:"'..message..'".');
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
			System:LogRuntimeError('Double click processing error (WindowName:"'..getString(window:GetName())..'", WindowId:'..getString(window:GetId())..', cursorX:'..getString(cursorX)..', cursorY:'..getString(cursorY)..'). Message:"'..message..'".');
		end
		windowErrorCheck(window, success, 'Double click processing error: ', message);
	end

	this.ProcessDoubleClickEvent = function(_, cursorX, cursorY)
		if (currentWindow ~= nil) then
			tryProcessDoubleClickEvent(currentWindow, cursorX, cursorY);
		end
	end

	local tryProcessLeftMouseDragEvent = function(window, newCursorX, newCursorY)
		local success, message = pcall(window.ProcessLeftMouseDragEventBase, nil, newCursorX, newCursorY);
		if (not success) then
			System:LogRuntimeError('Left mouse drag processing error (WindowName:"'..getString(window:GetName())..'", WindowId:'..getString(window:GetId())..', newCursorX:'..getString(newCursorX)..', newCursorY:'..getString(newCursorY)..'). Message:"'..message..'".');
		end
		windowErrorCheck(window, success, 'Left mouse drag processing error: ', message);
	end

	this.ProcessLeftMouseDragEvent = function(_, newCursorX, newCursorY)
		if (currentWindow ~= nil) then
			tryProcessLeftMouseDragEvent(currentWindow, newCursorX, newCursorY);
		end
	end

	local tryProcessRightMouseDragEvent = function(window, newCursorX, newCursorY)
		local success, message = pcall(window.ProcessRightMouseDragEventBase, nil, newCursorX, newCursorY);
		if (not success) then
			System:LogRuntimeError('Right mouse drag processing error (WindowName:"'..getString(window:GetName())..'", WindowId:'..getString(window:GetId())..', newCursorX:'..getString(newCursorX)..', newCursorY:'..getString(newCursorY)..'). Message:"'..message..'".');
		end
		windowErrorCheck(window, success, 'Right mouse drag processing error: ', message);
	end

	this.ProcessRightMouseDragEvent = function(_, newCursorX, newCursorY)
		if (currentWindow ~= nil) then
			tryProcessRightMouseDragEvent(currentWindow, newCursorX, newCursorY);
		end
	end

	local tryProcessMouseScrollEvent = function(window, direction, cursorX, cursorY)
		local success, message = pcall(window.ProcessMouseScrollEventBase, nil, direction, cursorX, cursorY);
		if (not success) then
			System:LogRuntimeError('Mouse scroll processing error (WindowName:"'..getString(window:GetName())..'", WindowId:'..getString(window:GetId())..', direction:'..getString(direction)..', cursorX:'..getString(newCursorX)..', cursorY:'..getString(newCursorY)..'). Message:"'..message..'".');
		end
		windowErrorCheck(window, success, 'Mouse scroll processing error: ', message);
	end

	this.ProcessMouseScrollEvent = function(_, direction, cursorX, cursorY)
		if (currentWindow ~= nil) then
			tryProcessMouseScrollEvent(currentWindow, direction, cursorX, cursorY);
		end
	end

	local tryProcessKeyEvent = function(window, key)
		local success, message = pcall(window.ProcessKeyEventBase, nil, key);
		if (not success) then
			System:LogRuntimeError('Key processing error (WindowName:"'..getString(window:GetName())..'", WindowId:'..getString(window:GetId())..', key:'..getString(key)..'). Message:"'..message..'".');
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
			System:LogRuntimeError('Char processing error (WindowName:"'..getString(window:GetName())..'", WindowId:'..getString(window:GetId())..', char:"'..getString(char)..'"). Message:"'..message..'".');
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
			System:LogRuntimeError('Rednet processing error (WindowName:"'..getString(window:GetName())..'", WindowId:'..getString(window:GetId())..', id:'..getString(id)..', data:"'..getString(data)..'"", distance:'..getString(distance)..'). Message:"'..message..'".');
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

	local tryDraw = function(window, videoBuffer)
		local success, message = pcall(window.DrawBase, nil, videoBuffer);
		if (not success) then
			System:LogRuntimeError('Drawing error (WindowName:"'..getString(window:GetName())..'", WindowId:'..getString(window:GetId())..'). Message:"'..message..'".');
		end
		windowErrorCheck(window, success, 'Drawing error: ', message);
	end

	this.Draw = function(_, videoBuffer)
		for i = 1, #windows do
			if (windows[i] ~= nil) then
				windows[i]:SetEnabled(false);
				tryDraw(windows[i], videoBuffer);
			end
		end
		if (currentWindow ~= nil) then
			currentWindow:SetEnabled(this.Enabled);
			tryDraw(currentWindow, videoBuffer);
		end
	end

	local tryUpdate = function(window)
		local success, message = pcall(window.UpdateBase, nil, videoBuffer);
		if (not success) then
			System:LogRuntimeError('Updating error (WindowName:"'..getString(window:GetName())..'", WindowId:'..getString(window:GetId())..'). Message:"'..message..'".');
		end
		windowErrorCheck(window, success, 'Updating error: ', message);
	end

	this.Update = function(_)
		if (currentWindow ~= nil and currentWindow:GetIsModal()) then
			tryUpdate(currentWindow);
		else
			for i = 1, #windows do
				tryUpdate(windows[i]);
			end
		end
	end
end)
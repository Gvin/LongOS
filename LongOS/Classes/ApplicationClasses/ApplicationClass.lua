Application = Class(function(a, applicationName, isUnique, _shutdownWhenNoWindows)
	a.Name = applicationName;
	a.IsUnique = isUnique;
	a.Enabled = true;
	a.Id = 'none';
	local windowsManager = WindowsManager();
	local shutdownWhenNoWindows = _shutdownWhenNoWindows;

	a.AddWindow = function(_, window)
		windowsManager:AddWindow(window);
	end

	a.DeleteWindow = function(_, windowId)
		windowsManager:DeleteWindow(windowId);
	end

	a.Run = function(_, window)
		if (window == nil and shutdownWhenNoWindows) then 
			return;
		end
		if (window == nil) then
			return;
		end
		windowsManager:AddWindow(window);
		System:AddApplication(a);
	end

	a.Draw = function(_, videoBuffer)
		windowsManager.Enabled = a.Enabled;
		windowsManager:Draw(videoBuffer);
	end

	a.Update = function(_)
		windowsManager:Update();

		if (shutdownWhenNoWindows and windowsManager:GetWindowsCount() == 0) then
			a:Close();
		end
	end

	a.Close = function(_)
		System:DeleteApplication(a.Id);
	end

	a.ProcessKeyEvent = function(_, key)
		windowsManager:ProcessKeyEvent(key);
	end

	a.ProcessCharEvent = function(_, char)
		windowsManager:ProcessCharEvent(char);
	end

	a.ProcessRednetEvent = function(_, id, message, distance)
		windowsManager:ProcessRednetEvent(id, message, distance);
	end

	a.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		return windowsManager:ProcessLeftClickEvent(cursorX, cursorY);
	end

	a.ProcessRightClickEvent = function(_, cursorX, cursorY)
		return windowsManager:ProcessRightClickEvent(cursorX, cursorY);
	end

	a.ProcessDoubleClickEvent = function(_, cursorX, cursorY)
		windowsManager:ProcessDoubleClickEvent(cursorX, cursorY);
	end

	a.Contains = function(_, x, y)
		return windowsManager:Contains(x, y);
	end

	a.GetWindowsCount = function(_)
		return windowsManager:GetWindowsCount();
	end
end)
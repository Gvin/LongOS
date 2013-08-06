ApplicationsManager = Class(function(a)

	a.GetClassName = function()
		return 'ApplicationsManager';
	end

	local applications = {};
	local applicationsToDelete = {};
	local currentApplication = nil;

	local getApplicationByName = function(_, applicationName)
		for i = 1, #applications do
			if (applications[i]:GetName() == applicationName) then
				return applications[i], i;
			end
		end
		return nil, nil;
	end

	local getApplicationById = function(applicationId)
		for i = 1, #applications do
			if (applications[i]:GetId() == applicationId) then
				return applications[i], i;
			end
		end
		return nil, nil;
	end

	local generateIdPart = function()
		return string.char(math.random(48, 122));
	end

	local generateId = function()
		local result = '';
		for i = 1, 20 do
			result = result..generateIdPart();
		end

		return result;
	end

	-- Add new applications to the applications collection.
	a.AddApplication = function(_, application)
		if (application:GetIsUnique()) then
			local oldApplication, index = getApplicationByName(application:GetName());
			if (oldApplication ~= nil) then
				currentApplication = oldApplication;
				return;
			end
		end

		application:SetId(generateId());
		table.insert(applications, application);
		currentApplication = application;
	end

	-- Delete application from the applications collection.
	a.DeleteApplication = function(_, applicationId)
		local applicationToDelete, indexToDelete = getApplicationById(applicationId);

		if (indexToDelete ~= nil and applicationToDelete:GetName() ~= 'Init') then
			table.insert(applicationsToDelete, applicationId);
		end
		if (applicationToDelete ~= nil and applicationToDelete:GetName() == 'Init') then
			System:ShowMessage('Warning', '  You cannot delete initial             application.');
		end
	end

	-- Draw all applications to the video buffer.
	a.Draw = function(_, videoBuffer)
		for i = 1, #applications do
			if (applications[i] ~= currentApplication) then
				applications[i]:SetEnabled(false);
				applications[i]:Draw(videoBuffer);
			end
		end

		currentApplication:SetEnabled(true);
		currentApplication:Draw(videoBuffer);
	end

	local selectNextAvailableApplication = function()
		currentApplication = applications[1];

		for i = 1, #applications do
			if (applications[i]:GetWindowsCount() > 0) then
				currentApplication = applications[i];
			end
		end
	end

	-- Update state of all applications.
	a.Update = function(_)
		if (currentApplication:GetWindowsCount() == 0) then
			a.SwitchApplication();
		end
			
		if (#applicationsToDelete > 0) then
			local applicationToDelete, indexToDelete = getApplicationById(applicationsToDelete[1]);
			table.remove(applications, indexToDelete);
			if (currentApplication:GetName() == applicationToDelete:GetName()) then
				selectNextAvailableApplication();
			end
			table.remove(applicationsToDelete, 1);
		end
		for i = 1, #applications do
			applications[i]:Update();
		end
	end

	-- Set selected application as current application.
	a.SetCurrentApplication = function(_, applicationId)
		local applicationToSet = getApplicationById(applicationId);
		currentApplication = applicationToSet;
	end

	-- Switch to the next application (like Alt + Tab).
	a.SwitchApplication = function(_)
		if (currentApplication ~= nil) then
			local application, index = getApplicationById(currentApplication:GetId());
			index = index + 1;
			if (index > #applications) then
				index = 1;
			end
			currentApplication = applications[index];
		end
	end

	a.ProcessKeyEvent = function(_, key)
		if currentApplication ~= nil then
			currentApplication:ProcessKeyEvent(key);
		end
	end

	a.ProcessCharEvent = function(_, char)
		if currentApplication ~= nil then
			currentApplication:ProcessCharEvent(char);
		end
	end

	a.ProcessRednetEvent = function(_, id, message, distance)
		for i = 1, #applications do
			applications[i]:ProcessRednetEvent(id, message, distance);
		end
	end

	a.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		if (currentApplication ~= nil) then
			currentApplication:ResetMoving();
			if (currentApplication:Contains(cursorX, cursorY)) then
				if (currentApplication:ProcessLeftClickEvent(cursorX, cursorY)) then
					return;
				end
			else
				for i = 1, #applications do
					applications[i]:ResetMoving();
					if (applications[i]:Contains(cursorX, cursorY)) then
						currentApplication = applications[i];
						return;
					end
				end
			end
		end
	end

	a.ProcessDoubleClickEvent = function(_, cursorX, cursorY)
		if (currentApplication ~= nil) then
			currentApplication:ProcessDoubleClickEvent(cursorX, cursorY);
		end
	end

	a.ProcessRightClickEvent = function(_, cursorX, cursorY)
		if (currentApplication ~= nil) then
			if (currentApplication:ProcessRightClickEvent(cursorX, cursorY)) then
				return true;
			end
		end
		return false;
	end

	a.ProcessLeftMouseDragEvent = function(_, newCursorX, newCursorY)
		if (currentApplication ~= nil) then
			if (currentApplication:ProcessLeftMouseDragEvent(newCursorX, newCursorY)) then
				return true;
			end
		end
		return false;
	end

	a.ProcessRightMouseDragEvent = function(_, newCursorX, newCursorY)
		if (currentApplication ~= nil) then
			if (currentApplication:ProcessRightMouseDragEvent(newCursorX, newCursorY)) then
				return true;
			end
		end
		return false;
	end

	a.ProcessTimerEvent = function(_, timerId)
		for i = 1, #applications do
			applications[i]:ProcessTimerEvent(timerId);
		end
	end

	a.ProcessRedstoneEvent = function()
		for i = 1, #applications do
			applications[i]:ProcessRedstoneEvent();
		end
	end

	a.ProcessMouseScrollEvent = function(_, direction, cursorX, cursorY)
		if (currentApplication ~= nil) then
			currentApplication:ProcessMouseScrollEvent(direction, cursorX, cursorY);
		end
	end

	a.GetApplicationsCount = function(_)
		return #applications;
	end

	a.GetApplicationsList = function(_)
		local result = {};
		for i = 1, #applications do
			local app = {};
			app.Id = applications[i]:GetId();
			app.Name = applications[i]:GetName();
			app.IsUnique = applications[i]:GetIsUnique();
			app.WindowsCount = applications[i]:GetWindowsCount();
			table.insert(result, app);
		end

		return result;
	end
end)
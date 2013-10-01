local MessageWindow = Classes.System.Windows.MessageWindow;

Classes.System.ApplicationsManager = Class(Object, function(this)
	Object.init(this, 'ApplicationsManager');

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local applications;
	local applicationsToDelete;
	local currentApplication;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function getApplicationByName(_applicationName)
		for i = 1, #applications do
			if (applications[i]:GetName() == _applicationName) then
				return applications[i], i;
			end
		end
		return nil, nil;
	end

	local function getApplicationById(_applicationId)
		for i = 1, #applications do
			if (applications[i]:GetId() == _applicationId) then
				return applications[i], i;
			end
		end
		return nil, nil;
	end

	local function generateIdPart()
		return string.char(math.random(48, 122));
	end

	local function generateId()
		local result = '';
		for i = 1, 20 do
			result = result..generateIdPart();
		end

		return result;
	end

	function this:AddApplication(_application)
		if (_application:GetIsUnique()) then
			local oldApplication, index = getApplicationByName(_application:GetName());
			if (oldApplication ~= nil) then
				currentApplication = oldApplication;
				return;
			end
		end

		_application:Initialize(generateId());
		table.insert(applications, _application);
		currentApplication = _application;
	end

	function this:RemoveApplication(_applicationId)
		local applicationToDelete, indexToDelete = getApplicationById(_applicationId);

		if (indexToDelete ~= nil and applicationToDelete:GetName() ~= 'Init') then
			table.insert(applicationsToDelete, _applicationId);
		end
		if (applicationToDelete ~= nil and applicationToDelete:GetName() == 'Init') then
			System:ShowMessage('Warning', '  You cannot delete initial             application.');
		end
	end

	function this:SetCurrentApplication(_applicationId)
		local applicationToSet = getApplicationById(_applicationId);
		currentApplication = applicationToSet;
	end

	function this:SwitchApplication()
		if (currentApplication ~= nil) then
			local application, index = getApplicationById(currentApplication:GetId());
			index = index + 1;
			if (index > #applications) then
				index = 1;
			end
			currentApplication = applications[index];
		end
	end

	local function getString(_variable)
		if (_variable == nil) then
			return 'nil';
		elseif (type(_variable) == 'table') then
			return 'table';
		elseif (type(_variable) == 'function') then
			return 'function';
		elseif (type(_variable) == 'boolean') then
			if (_variable) then
				return 'true';
			else
				return 'false';
			end
		end
		return ''.._variable;
	end

	local function showError(_application, _errorText, _message)
		_application:Clear();
		local errorWindow = MessageWindow(_application, 'Error', 'Error message: '.._errorText.._message, colors.red);
		errorWindow:ShowModal();
	end

	local function tryDraw(_application, _videoBuffer)
		local success, message = pcall(_application.Draw, _application, _videoBuffer);
		if (not success) then
			if (message == nil) then
				message = '';
			end
			System:LogRuntimeError('Drawing error (ApplicationName:"'..getString(_application:GetName())..'", ApplicationId:'..getString(_application:GetId())..'). Message:"'..message..'".');
			showError(_application, 'Drawing error: ', message);
		end
	end

	function this:Draw(_videoBuffer)
		for i = 1, #applications do
			if (applications[i] ~= currentApplication) then
				applications[i]:SetEnabled(false);
				tryDraw(applications[i], _videoBuffer);
			end
		end

		currentApplication:SetEnabled(true);
		tryDraw(currentApplication, _videoBuffer);
	end

	local function selectNextAvailableApplication()
		currentApplication = applications[1];

		for i = 1, #applications do
			if (applications[i]:GetWindowsCount() > 0) then
				currentApplication = applications[i];
			end
		end
	end

	local function tryUpdate(_application)
		local success, message = pcall(_application.Update, _application);
		if (not success) then
			if (message == nil) then
				message = '';
			end
			System:LogRuntimeError('Updating error (ApplicationName:"'..getString(_application:GetName())..'", ApplicationId:'..getString(_application:GetId())..'). Message:"'..message..'".');
			showError(_application, 'Updating error: ', message);
		end
	end

	function this:Update()
		if (currentApplication:GetWindowsCount() == 0) then
			this:SwitchApplication();
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
			tryUpdate(applications[i])
		end
	end

	local function tryProcessKeyEvent(_application, _key)
		local success, message = pcall(_application.ProcessKeyEvent, _application, _key);
		if (not success) then
			if (message == nil) then
				message = '';
			end
			System:LogRuntimeError('Key processing error (ApplicationName:"'..getString(_application:GetName())..'", ApplicationId:'..getString(_application:GetId())..', Key:'..getString(_key)..'). Message:"'..message..'".');
			showError(_application, 'Key processing error: ', message);
		end
	end

	function this:ProcessKeyEvent(_key)
		if currentApplication ~= nil then
			tryProcessKeyEvent(currentApplication, _key);
		end
	end

	local function tryProcessCharEvent(_application, _char)
		local success, message = pcall(_application.ProcessCharEvent, _application, _char);
		if (not success) then
			if (message == nil) then
				message = '';
			end
			System:LogRuntimeError('Char processing error (ApplicationName:"'..getString(_application:GetName())..'", ApplicationId:'..getString(_application:GetId())..', Char:'..getString(_char)..'). Message:"'..message..'".');
			showError(_application, 'Char processing error: ', message);	
		end
	end

	function this:ProcessCharEvent(_char)
		if currentApplication ~= nil then
			tryProcessCharEvent(currentApplication, _char);
		end
	end

	local function tryProcessRednetEvent(_application, _id, _message, _distance, _side, _channel)
		local success, message = pcall(_application.ProcessRednetEvent, _application, _id, _message, _distance, _side, _channel);
		if (not success) then
			if (message == nil) then
				message = '';
			end
			System:LogRuntimeError('Rednet processing error (ApplicationName:"'..getString(_application:GetName())..'", ApplicationId:'..getString(_application:GetId())..', Id:'..getString(_id)..', Message:'..getString(_message)..', Distance:'..getString(_distance)..'). Message:"'..message..'".');
			showError(_application, 'Rednet processing error: ', message);
		end
	end

	function this:ProcessRednetEvent(_id, _message, _distance, _side, _channel)
		for i = 1, #applications do
			tryProcessRednetEvent(applications[i], _id, _message, _distance, _side, _channel);
		end
	end

	local function tryProcessLeftClickEvent(_application, _cursorX, _cursorY)
		local success, message = pcall(_application.ProcessLeftClickEvent, _application, _cursorX, _cursorY);
		if (not success) then
			if (message == nil) then
				message = '';
			end
			System:LogRuntimeError('Left click processing error (ApplicationName:"'..getString(_application:GetName())..'", ApplicationId:'..getString(_application:GetId())..', CursorX:'..getString(_cursorX)..', CursorY:'..getString(_cursorY)..'). Message:"'..message..'".');
			showError(_application, 'Left click processing error: ', message);
		end

		return message;
	end

	function this:ProcessLeftClickEvent(_cursorX, _cursorY)
		if (currentApplication ~= nil) then
			currentApplication:ResetDragging();
			if (currentApplication:Contains(_cursorX, _cursorY)) then
				if (tryProcessLeftClickEvent(currentApplication, _cursorX, _cursorY)) then
					return;
				end
			else
				for i = 1, #applications do
					applications[i]:ResetDragging();
					if (applications[i]:Contains(_cursorX, _cursorY)) then
						currentApplication = applications[i];
						return;
					end
				end
			end
		end
	end

	local function tryProcessDoubleClickEvent(_application, _cursorX, _cursorY)
		local success, message = pcall(_application.ProcessDoubleClickEvent, _application, _cursorX, _cursorY);
		if (not success) then
			if (message == nil) then
				message = '';
			end
			System:LogRuntimeError('Double click processing error (ApplicationName:"'..getString(_application:GetName())..'", ApplicationId:'..getString(_application:GetId())..', CursorX:'..getString(_cursorX)..', CursorY:'..getString(_cursorY)..'). Message:"'..message..'".');
			showError(_application, 'Double click processing error: ', message);
		end
	end

	function this:ProcessDoubleClickEvent(_cursorX, _cursorY)
		if (currentApplication ~= nil) then
			tryProcessDoubleClickEvent(currentApplication, _cursorX, _cursorY);
		end
	end

	local function tryProcessRightClickEvent(_application, _cursorX, _cursorY)
		local success, message = pcall(_application.ProcessRightClickEvent, _application, _cursorX, _cursorY);
		if (not success) then
			if (message == nil) then
				message = '';
			end
			System:LogRuntimeError('Right click processing error (ApplicationName:"'..getString(_application:GetName())..'", ApplicationId:'..getString(_application:GetId())..', CursorX:'..getString(_cursorX)..', CursorY:'..getString(_cursorY)..'). Message:"'..message..'".');
			showError(_application, 'Right click processing error: ', message);
		end

		return message;
	end

	function this:ProcessRightClickEvent(_cursorX, _cursorY)
		if (currentApplication ~= nil and currentApplication:Contains(_cursorX, _cursorY)) then
			if (tryProcessRightClickEvent(currentApplication, _cursorX, _cursorY)) then
				return true;
			end
		end
		return false;
	end

	local function tryProcessLeftMouseDragEvent(_application, _newCursorX, _newCursorY)
		local success, message = pcall(_application.ProcessLeftMouseDragEvent, _application, _newCursorX, _newCursorY);
		if (not success) then
			if (message == nil) then
				message = '';
			end
			System:LogRuntimeError('Left mouse drag processing error (ApplicationName:"'..getString(_application:GetName())..'", ApplicationId:'..getString(_application:GetId())..', NewCursorX:'..getString(_newCursorX)..', NewCursorY:'..getString(_newCursorY)..'). Message:"'..message..'".');
			showError(_application, 'Left mouse drag processing error: ', message);
		end

		return message;
	end

	function this:ProcessLeftMouseDragEvent(_newCursorX, _newCursorY)
		if (currentApplication ~= nil) then
			if (tryProcessLeftMouseDragEvent(currentApplication, _newCursorX, _newCursorY)) then
				return true;
			end
		end
		return false;
	end

	local function tryProcessRightMouseDragEvent(_application, _newCursorX, _newCursorY)
		local success, message = pcall(_application.ProcessRightMouseDragEvent, _application, _newCursorX, _newCursorY);
		if (not success) then
			if (message == nil) then
				message = '';
			end
			System:LogRuntimeError('Right mouse drag processing error (ApplicationName:"'..getString(_application:GetName())..'", ApplicationId:'..getString(_application:GetId())..', NewCursorX:'..getString(_newCursorX)..', NewCursorY:'..getString(_newCursorY)..'). Message:"'..message..'".');
			showError(_application, 'Right mouse drag processing error: ', message);
		end

		return message;
	end

	function this:ProcessRightMouseDragEvent(_newCursorX, _newCursorY)
		if (currentApplication ~= nil) then
			if (currentApplication:ProcessRightMouseDragEvent(_newCursorX, _newCursorY)) then
				return true;
			end
		end
		return false;
	end

	local function tryProcessTimerEvent(_application, _timerId)
		local success, message = pcall(_application.ProcessTimerEvent, _application, _timerId);
		if (not success) then
			if (message == nil) then
				message = '';
			end
			System:LogRuntimeError('Timer processing error (ApplicationName:"'..getString(_application:GetName())..'", ApplicationId:'..getString(_application:GetId())..', TimerId:'..getString(_timerId)..'). Message:"'..message..'".');
			showError(_application, 'Timer processing error: ', message);
		end
	end

	function this:ProcessTimerEvent(_timerId)
		for i = 1, #applications do
			tryProcessTimerEvent(applications[i], _timerId);
		end
	end

	local function tryProcessRedstoneEvent(_application)
		local success, message = pcall(_application.ProcessRedstoneEvent, _application);
		if (not success) then
			if (message == nil) then
				message = '';
			end
			System:LogRuntimeError('Redstone processing error (ApplicationName:"'..getString(_application:GetName())..'", ApplicationId:'..getString(_application:GetId())..'). Message:"'..message..'".');
			showError(_application, 'Redstone processing error: ', message);
		end
	end

	function this:ProcessRedstoneEvent()
		for i = 1, #applications do
			tryProcessRedstoneEvent(applications[i]);
		end
	end

	local function tryProcessMouseScrollEvent(_application, _direction, _cursorX, _cursorY)
		local success, message = pcall(_application.ProcessMouseScrollEvent, _application, _direction, _cursorX, _cursorY);
		if (not success) then
			if (message == nil) then
				message = '';
			end
			System:LogRuntimeError('Mouse scroll processing error (ApplicationName:"'..getString(_application:GetName())..'", ApplicationId:'..getString(_application:GetId())..', Direction:'..getString(_direction)..', CursorX:'..getString(_cursorX)..', CursorY:'..getString(_cursorY)..'). Message:"'..message..'".');
			showError(_application, 'Mouse scroll processing error: ', message);
		end

		return message;
	end

	function this:ProcessMouseScrollEvent(_direction, _cursorX, _cursorY)
		if (currentApplication ~= nil) then
			tryProcessMouseScrollEvent(currentApplication, _direction, _cursorX, _cursorY);
		end
	end

	local function tryProcessHttpEvent(_application, _status, _url, _handler)
		local success, message = pcall(_application.ProcessHttpEvent, _application, _status, _url, _handler);
		if (not success) then
			if (message == nil) then
				message = '';
			end
			System:LogRuntimeError('Http event processing error (ApplicationName:"'..getString(_application:GetName())..'", ApplicationId:'..getString(_application:GetId())..', Status:'..getString(_status)..', Url:'..getString(_url)..'). Message:"'..message..'".');
			showError(_application, 'Http event processing error: ', message);
		end
	end

	function this:ProcessHttpEvent(_status, _url, _handler)
		for i = 1, #applications do
			tryProcessHttpEvent(applications[i], _status, _url, _handler);
		end
	end

	function this:GetApplicationsCount()
		return #applications;
	end

	function this:GetApplicationsList()
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

	------------------------------------------------------------------------------------------------------------------
	----- Constuctors ------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor()
		applications = {};
		applicationsToDelete = {};
		currentApplication = nil;
	end

	constructor();
end)
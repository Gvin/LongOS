Classes.Application.Thread = Class(Object, function(this, _application, _operation)
	Object.init(this, 'Thread');

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local application;
	local id;
	local operation;

	local routine;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:GetId()
		return id;
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:Initialize(_id)
		if (type(_id) ~= 'string') then
			error('Thread.Initialize [id]: String expected, got '..type(_id)..'.');
		end

		id = _id;
		routine = coroutine.create(operation);
	end

	function this:Start()
		application:AddThread(this);
	end

	function this:Stop()
		application:RemoveThread(id);
	end

	function this:Resume(_eventData)
		return coroutine.resume(routine, unpack(_eventData));
	end

	function this:GetStatus()
		if (routine == nil) then
			return 'none';
		end

		return coroutine.status(routine);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor(_application, _operation)
		if (type(_application) ~= 'table' or _application.GetClassName == nil or _application:GetClassName() ~= 'Application') then
			error('Thread.Constructor [application]: Application expected, got '..type(_application)..'.');
		end
		if (type(_operation) ~= 'function') then
			error('Thread.Constructor [operation]: Function expected, got '..type(_operation)..'.');
		end

		application = _application;
		operation = _operation;
		routine = nil;
	end

	constructor(_application, _operation);
end)
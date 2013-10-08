local EventHandler = Classes.System.EventHandler;

Classes.Application.Thread = Class(Object, function(this, _application, _operation)
	Object.init(this, 'Thread');

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local application;
	local id;
	local operation;
	local isPaused;

	local routine;

	local onStart;
	local onStop;
	local onPause;
	local onResume;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:GetId()
		return id;
	end

	function this:GetIsPaused()
		return isPaused;
	end

	function this:AddOnStartEventHandler(_value)
		onStart:AddHandler(_value);
	end

	function this:AddOnStopEventHandler(_value)
		onStop:AddHandler(_value);
	end

	function this:AddOnPauseEventHandler(_value)
		onPause:AddHandler(_value)
	end

	function this:AddOnResumeEventHandler(_value)
		onResume:AddHandler(_value);
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
		onStart:Invoke(this, {});
	end

	function this:Stop()
		application:RemoveThread(id);
		onStop:Invoke(this, {});
	end

	function this:Pause()
		isPaused = true;
		onPause:Invoke(this, {});
	end

	function this:Resume()
		isPaused = false;
		onResume:Invoke(this, {});
	end

	function this:ResumeRoutine(_eventData)
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
		isPaused = false;

		onStart = EventHandler();
		onStop = EventHandler();
		onPause  = EventHandler();
		onResume = EventHandler();
	end

	constructor(_application, _operation);
end)
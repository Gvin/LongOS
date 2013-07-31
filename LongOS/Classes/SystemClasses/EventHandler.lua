EventHandler = Class(function(this, _operation)

	this.GetClassName = function()
		return 'EventHandler';
	end

	----- Fields -----

	local operation;

	----- Methods -----

	this.Invoke = function(_, _sender, _eventArgs)
		operation(_sender, _eventArgs);
	end

	----- Constructors -----

	local constructor = function(_operation)
		operation = _operation;
	end

	if (type(_operation) ~= 'function') then
		error('EventHandler.Constructor [operation]: Function expected, got '..type(_operation)..'.');
	end

	constructor(_operation);
end)
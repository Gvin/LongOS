local Label = Classes.Components.Label;
local EventHandler = Classes.System.EventHandler;

Button = Class(Label, function(this, _text, _backgroundColor, _textColor, _dX, _dY, _anchorType)

	if (_backgroundColor == nil) then
		local configuration = System:GetColorConfiguration();
		_backgroundColor = configuration:GetColor('SystemButtonsColor');
	end
	if (_textColor == nil) then
		local configuration = System:GetColorConfiguration();
		_textColor = configuration:GetColor('SystemButtonsTextColor');
	end

	Label.init(this, _text, _backgroundColor, _textColor, _dX, _dY, _anchorType);
	
	function this:GetClassName()
		return 'Button';
	end

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local enabled;

	local onClick;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:GetEnabled()
		return enabled;
	end

	function this:SetEnabled(_value)
		if (type(_value) ~= 'boolean') then
			error('Button.SetEnabled [value]: Boolean expected, got '..type(_value)..'.');
		end

		enabled = _value;
	end

	function this:AddOnClickEventHandler(_value)
		onClick:AddHandler(_value);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function click(_cursorX, _cursorY)
		local eventArgs = {};
		eventArgs['X'] = _cursorX;
		eventArgs['Y'] = _cursorY;
		onClick:Invoke(this, eventArgs);
	end

	local function processClickEvent(_cursorX, _cursorY)
		if (not enabled or not this:GetVisible()) then return false; end
		
		if (this:Contains(_cursorX, _cursorY)) then
			click(_cursorX, _cursorY);
			return true;
		end
		return false;
	end

	function this:ProcessLeftClickEvent(_cursorX, _cursorY)
		if (type(_cursorX) ~= 'number') then
			error('Button.ProcessLeftClickEvent [cursorX]: Number required , got '..type(_cursorX)..'.');
		end
		if (type(_cursorY) ~= 'number') then
			error('Button.ProcessLeftClickEvent [cursorY]: Number required , got '..type(_cursorY)..'.');
		end

		return processClickEvent(_cursorX, _cursorY);
	end

	function this:ProcessDoubleClickEvent(_cursorX, _cursorY)
		if (type(_cursorX) ~= 'number') then
			error('Button.ProcessDoubleClickEvent [cursorX]: Number required , got '..type(_cursorX)..'.');
		end
		if (type(_cursorY) ~= 'number') then
			error('Button.ProcessDoubleClickEvent [cursorY]: Number required , got '..type(_cursorY)..'.');
		end

		return processClickEvent(_cursorX, _cursorY);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor()
		enabled = true;
		onClick = EventHandler();
	end

	constructor();
end)
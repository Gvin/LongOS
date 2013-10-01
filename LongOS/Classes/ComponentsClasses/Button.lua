local Label = Classes.Components.Label;
local EventHandler = Classes.System.EventHandler;

Classes.Components.Button = Class(Label, function(this, _text, _backgroundColor, _textColor, _dX, _dY, _anchorType)

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
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local onClick;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

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
		if (this:Contains(_cursorX, _cursorY)) then
			click(_cursorX, _cursorY);
			return true;
		end
		return false;
	end

	function this:ProcessLeftClickEvent(_cursorX, _cursorY)
		if (type(_cursorX) ~= 'number') then
			error(this:GetClassName()..'.ProcessLeftClickEvent [cursorX]: Number required , got '..type(_cursorX)..'.');
		end
		if (type(_cursorY) ~= 'number') then
			error(this:GetClassName()..'.ProcessLeftClickEvent [cursorY]: Number required , got '..type(_cursorY)..'.');
		end

		return processClickEvent(_cursorX, _cursorY);
	end

	function this:ProcessDoubleClickEvent(_cursorX, _cursorY)
		if (type(_cursorX) ~= 'number') then
			error(this:GetClassName()..'.ProcessDoubleClickEvent [cursorX]: Number required , got '..type(_cursorX)..'.');
		end
		if (type(_cursorY) ~= 'number') then
			error(this:GetClassName()..'.ProcessDoubleClickEvent [cursorY]: Number required , got '..type(_cursorY)..'.');
		end

		return processClickEvent(_cursorX, _cursorY);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor()
		onClick = EventHandler();
	end

	constructor();
end)
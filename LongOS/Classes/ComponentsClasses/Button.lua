Button = Class(Component, function(this, _text, _backgroundColor, _textColor, _dX, _dY, _anchorType)
	Component.init(this, _dX, _dY, _anchorType);
	
	this.GetClassName = function()
		return 'Button';
	end

	----- Fields -----

	local text;
	local backgroundColor;
	local textColor;
	local enabled;

	local onClick;
	
	local x;
	local y;

	----- Properties -----

	this.GetText = function()
		return text;
	end

	this.SetText = function(_, _value)
		text = _value;
	end

	this.GetBackgroundColor = function()
		return backgroundColor;
	end

	this.SetBackgroundColor = function(_, _value)
		backgroundColor = _value;
	end

	this.GetTextColor = function()
		return textColor;
	end

	this.SetTextColor = function(_, _value)
		textColor = _value;
	end

	this.GetEnabled = function()
		return enabled;
	end

	this.SetEnabled = function(_, _value)
		enabled = _value;
	end

	this.SetOnClick = function(_, _value)
		if (type(_value) ~= 'table' or _value:GetClassName() ~= 'EventHandler') then
			error('Button.SetOnClick [value]: EventHandler expected, got '..type(_value)..'.');
		end

		onClick = _value;
	end

	this.GetX = function()
		return x;
	end

	this.GetY = function()
		return y;
	end

	----- Methods -----

	this._draw = function(_videoBuffer, _x, _y)
		local colorConfiguration = System:GetColorConfiguration();
		if (_backgroundColor == nil) then
			backgroundColor = colorConfiguration:GetColor('SystemButtonsColor');
		end
		if (_textColor == nil) then
			textColor = colorConfiguration:GetColor('SystemButtonsTextColor');
		end

		x = _x;
		y = _y;
		_videoBuffer:SetBackgroundColor(backgroundColor);
		_videoBuffer:SetTextColor(textColor);
		_videoBuffer:WriteAt(x, y, text);
	end

	this.Contains = function(_, _x, _y)
		if (type(_x) ~= 'number') then
			error('Button.Contains [x]: Number required, got '..type(_x)..'.');
		end
		if (type(_y) ~= 'number') then
			error('Button.Contains [y]: Number required, got '..type(_y)..'.');
		end

		return (_y == y and _x >= x and _x <= x + string.len(text) - 1);
	end

	local click = function(cursorX, cursorY)
		if (onClick ~= nil) then
			local eventArgs = {};
			eventArgs['X'] = cursorX;
			eventArgs['Y'] = cursorY;
			onClick:Invoke(this, eventArgs);
		end
	end

	local processClickEvent = function(cursorX, cursorY)
		if (type(cursorX) ~= 'number') then
			error('Button: ProcessClickEvent - Number required (variable "cursorX").');
		end
		if (type(cursorY) ~= 'number') then
			error('Button: ProcessClickEvent - Number required (variable "cursorY").');
		end

		if (not enabled) then return false; end
		
		if (this:Contains(cursorX, cursorY)) then
			click(cursorX, cursorY);
			return true;
		end
		return false;
	end

	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		return processClickEvent(cursorX, cursorY);
	end

	this.ProcessDoubleClickEvent = function(_, cursorX, cursorY)
		return processClickEvent(cursorX, cursorY);
	end

	----- Constructors -----

	local constructor = function(_text, _backgroundColor, _textColor, _dX, _dY, _anchorType)
		text = _text;
		backgroundColor = _backgroundColor;
		textColor = _textColor;
		x = _dX;
		y = _dY;
		enabled = true;
		onClick = nil;
	end

	if (type(_text) ~= 'string') then
		error('Button.Constructor [text]: String expected, got '..type(_text)..'.');
	end
	if (_backgroundColor ~= nil and type(_backgroundColor) ~= 'number') then
		error('Button.Constructor [backgroundColor]: Number expected, got '..type(_backgroundColor)..'.');
	end
	if (_textColor ~= nil and type(_textColor) ~= 'number') then
		error('Button.Constructor [textColor]: Number expected, got '..type(_textColor)..'.');
	end

	constructor(_text, _backgroundColor, _textColor, _dX, _dY, _anchorType);
end);
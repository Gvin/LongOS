Classes.Components.Label = Class(Classes.Components.Component, function(this, _text, _backgroundColor, _textColor, _dX, _dY, _anchorType)
	Classes.Components.Component.init(this, _dX, _dY, _anchorType);

	function this.GetClassName()
		return 'Label';
	end

	function this:ToString()
		return this:GetText();
	end

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local text;
	local textColor;
	local backgroundColor;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this.GetText()
		return text;
	end

	function this.SetText(_, _value)
		if (type(_value) ~= 'string') then
			error(this:GetClassName()..'.SetText [value]: String expected, got '..type(_value)..'.');
		end

		text = _value;
	end

	function this.GetWidth()
		return string.len(text);
	end

	function this.GetBackgroundColor()
		return backgroundColor;
	end

	function this.SetBackgroundColor(_, _value)
		if (type(_value) ~= 'number') then
			error(this:GetClassName()..'.SetBackgroundColor [value]: Number expected, got '..type(_value)..'.');
		end

		backgroundColor = _value;
	end

	function this.GetTextColor()
		return textColor;
	end

	function this.SetTextColor(_, _value)
		if (type(_value) ~= 'number') then
			error(this:GetClassName()..'.SetTextColor [value]: Number expected, got '..type(_value)..'.');
		end

		textColor = _value;
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this.Draw(_, _videoBuffer, _x, _y)
		_videoBuffer:SetTextColor(textColor);
		_videoBuffer:SetBackgroundColor(backgroundColor);
		_videoBuffer:WriteAt(_x, _y, text);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor(_text, _backgroundColor, _textColor)
		if (type(_text) ~= 'string') then
			error(this:GetClassName()..'.Constructor [text]: String expected, got '..type(_text)..'.');
		end
		if (_backgroundColor ~= nil and type(_backgroundColor) ~= 'number') then
			error(this:GetClassName()..'.Constructor [backgroundColor]: Number or nil expected, got '..type(_backgroundColor)..'.');
		end
		if (_textColor ~= nil and type(_textColor) ~= 'number') then
			error(this:GetClassName()..'.Constructor [textColor]: Number or nil expected, got '..type(_textColor)..'.');
		end

		text = _text;
		textColor = _textColor;
		backgroundColor = _backgroundColor;

		if (textColor == nil) then
			local colorConfiguration = System:GetColorConfiguration();
			textColor = colorConfiguration:GetColor('SystemLabelsTextColor');
		end
		if (backgroundColor == nil) then
			local colorConfiguration = System:GetColorConfiguration();
			backgroundColor = colorConfiguration:GetColor('WindowColor');
		end

		visible = true;
	end

	constructor(_text, _backgroundColor, _textColor)
end)
Label = Class(Classes.Components.Component, function(this, _text, _backgroundColor, _textColor, _dX, _dY, _anchorType)
	Classes.Components.Component.init(this, _dX, _dY, _anchorType);

	function this.GetClassName()
		return 'Label';
	end

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local text;
	local textColor;
	local backgroundColor;
	local visible;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this.GetText()
		return text;
	end

	function this.SetText(_, _value)
		if (type(_value) ~= 'string') then
			error('Label.SetText [value]: String expected, got '..type(_value)..'.');
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
			error('Label.SetBackgroundColor [value]: Number expected, got '..type(_value)..'.');
		end

		backgroundColor = _value;
	end

	function this.GetTextColor()
		return textColor;
	end

	function this.SetTextColor(_, _value)
		if (type(_value) ~= 'number') then
			error('Label.SetTextColor [value]: Number expected, got '..type(_value)..'.');
		end

		textColor = _value;
	end

	function this.GetVisible()
		return visible;
	end

	function this.SetVisible(_, _value)
		if (type(_value) ~= 'boolean') then
			error('Label.SetVisible [value]: Boolean expected, got '..type(_value)..'.');
		end

		visible = _value;
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this._draw(_, _videoBuffer, _x, _y)
		if (visible) then
			_videoBuffer:SetTextColor(textColor);
			_videoBuffer:SetBackgroundColor(backgroundColor);
			_videoBuffer:WriteAt(_x, _y, text);
		end
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor(_text, _backgroundColor, _textColor)
		if (type(_text) ~= 'string') then
			error('Label.Constructor [text]: String expected, got '..type(_text)..'.');
		end
		if (_backgroundColor ~= nil and type(_backgroundColor) ~= 'number') then
			error('Label.Constructor [backgroundColor]: Number or nil expected, got '..type(_backgroundColor)..'.');
		end
		if (_textColor ~= nil and type(_textColor) ~= 'number') then
			error('Label.Constructor [textColor]: Number or nil expected, got '..type(_textColor)..'.');
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
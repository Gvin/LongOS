Classes.System.Graphics.Pixel = Class(Object, function(this, _initBackColor, _initTextColor, _initSymbol)
	Object.init(this, 'Pixel');

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local backgroundColor;
	local textColor;
	local symbol;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:GetBackgroundColor()
		return backgroundColor;
	end

	function this:SetBackgroundColor(_value)
		if (type(_value) ~= 'number') then
			error('Pixel.SetBackgroundColor [value]: Number expected, got '..type(_value)..'.');
		end

		backgroundColor = _value;
	end

	function this:GetTextColor()
		return textColor;
	end

	function this:SetTextColor(_value)
		if (type(_value) ~= 'number') then
			error('Pixel.SetTextColor [value]: number expected, got '..type(_value)..'.');
		end

		textColor = _value;
	end

	function this:GetSymbol()
		return symbol;
	end

	function this:SetSymbol(_value)
		if (type(_value) ~= 'string') then
			error('Pixel.SetSymbol: string expected, got '..type(_value)..'.');
		end

		local newSymbol = ''..string.sub(_value, 1, 1);
		symbol = newSymbol;
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:DrawAt(_x, _y)
		if (type(_x) ~= 'number') then
			error('Pixel.DrawAt [x]: number expected, got '..type(_x)..'.');
		end

		if (type(_y) ~= 'number') then
			error('Pixel.DrawAt [y]: number expected, got '..type(_y)..'.');
		end

		if (symbol == '') then
			paintutils.drawPixel(_x, _y, backgroundColor);
		else
			term.setTextColor(textColor);
			term.setBackgroundColor(backgroundColor);
			term.setCursorPos(_x, _y);
			term.write(symbol);
		end
	end

	function this:Clear()
		backgroundColor = colors.black;
		textColor = colors.white;
		symbol = '';
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor(_initBackColor, _initTextColor, _initSymbol)
		if (_initBackColor ~= nil and type(_initBackColor) ~= 'number') then
			error('Pixel.Constructor [initBackColor]: Number or nil expected, got '..type(_initBackColor)..'.');
		end
		if (_initTextColor ~= nil and type(_initTextColor) ~= 'number') then
			error('Pixel.Constructor [initTextColor]: Number or nil expected, got '..type(_initTextColor)..'.');
		end
		if (_initSymbol ~= nil and type(_initSymbol) ~= 'string') then
			error('Pixel.Constructor [initSymbol]: String or nil expected, got '..type(_initSymbol)..'.');
		end

		backgroundColor = _initBackColor or colors.black;
		textColor = _initTextColor or colors.white;

		symbol = '';
		if (initSymbol ~= nil) then
			symbol = ''..string.sub(initSymbol, 1, 1);
		end
	end

	constructor(_initBackColor, _initTextColor, _initSymbol)
end)
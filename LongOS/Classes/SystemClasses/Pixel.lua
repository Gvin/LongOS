Pixel = Class(function(this, initBackColor, initTextColor, initSymbol)
	this.GetClassName = function()
		return "Pixel";
	end

	local backgroundColor = initBackColor;
	local textColor = initTextColor;

	if (backgroundColor == nil) then
		backgroundColor = colors.black;
	end
	if (textColor == nil) then
		textColor = colors.white;
	end

	local symbol = '';

	if (initSymbol ~= nil) then
		symbol = ''..string.sub(initSymbol, 1, 1);
	end

	this.GetBackgroundColor = function()
		return backgroundColor;
	end

	this.SetBackgroundColor = function(_, value)
		if (type(value) ~= 'number') then
			error('Pixel.SetBackgroundColor: number expected, got '..type(value)..'.');
		end

		backgroundColor = value;
	end

	this.GetTextColor = function()
		return textColor;
	end

	this.SetTextColor = function(_, value)
		if (type(value) ~= 'number') then
			error('Pixel.SetTextColor: number expected, got '..type(value)..'.');
		end

		textColor = value;
	end

	this.GetSymbol = function()
		return symbol;
	end

	this.SetSymbol = function(_, value)
		if (type(value) ~= 'string') then
			error('Pixel.SetSymbol: string expected, got '..type(value)..'.');
		end

		symbol = ''..string.sub(value, 1, 1);
	end

	this.DrawAt = function(_, x, y)
		if (type(x) ~= 'number') then
			error('Pixel.DrawAt [x]: number expected, got '..type(x)..'.');
		end

		if (type(y) ~= 'number') then
			error('Pixel.DrawAt [y]: number expected, got '..type(y)..'.');
		end

		if (symbol == '') then
			paintutils.drawPixel(x, y, backgroundColor);
		else
			term.setTextColor(textColor);
			term.setBackgroundColor(backgroundColor);
			term.setCursorPos(x, y);
			term.write(symbol);
		end
	end

	this.Clear = function()
		backgroundColor = colors.black;
		textColor = colors.white;
		symbol = '';
	end
end)
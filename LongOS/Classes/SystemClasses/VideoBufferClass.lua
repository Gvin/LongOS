VideoBuffer = Class(function(this)
	
	this.GetClassName = function()
		return 'VideoBuffer';
	end

	local pixels = {};

	local currentBackgroundColor = colors.black;
	local currentTextColor = colors.white;
	local cursorX = 1;
	local cursorY = 1;
	local realCursorX = 1;
	local realCursorY = 1;
	local cursorBlink = false;

	local screenWidth, screenHeight = term.getSize();
	for i = 1, screenHeight do
		pixels[i] = {};
		for j = 1, screenWidth do
			pixels[i][j] = Pixel();
		end
	end

	local isOnScreen = function(x, y)
		return (x >= 1 and x <= screenWidth and y >= 1 and y <= screenHeight);
	end

	this.SetRealCursorPos = function(_, x, y)
		if (type(x) ~= 'number') then
			error('VideoBuffer:SetRealCursorPos - Number required (variable "x").');
		end
		if (type(y) ~='number') then
			error('VideoBuffer:SetRealCursorPos - Number required (variable "y").');
		end	

		realCursorX = x;
		realCursorY = y;
	end

	this.SetCursorPos = function(_, x, y)
		if (type(x) ~= 'number') then
			error('VideoBuffer:SetCursorPos - Number required (variable "x").');
		end
		if (type(y) ~='number') then
			error('VideoBuffer:SetCursorPos - Number required (variable "y").');
		end

		cursorX = x;
		cursorY = y;
	end

	this.SetBackgroundColor = function(_, color)
		currentBackgroundColor = color;
	end

	this.SetPixelColor = function(_, x, y, color)
		if (type(x) ~= 'number') then
			error('VideoBuffer:SetPixelColor - Number required (variable "x").');
		end
		if (type(y) ~='number') then
			error('VideoBuffer:SetPixelColor - Number required (variable "y").');
		end

		if (isOnScreen(x, y)) then
			pixels[y][x]:SetBackgroundColor(color);
		end
	end

	this.SetTextColor = function(_, color)
		currentTextColor = color;
	end

	this.DrawBlock = function(_, x, y, width, height, color, symbol)
		if (type(x) ~= 'number') then
			error('VideoBuffer:DrawBlock - Number required (variable "x").');
		end
		if (type(y) ~='number') then
			error('VideoBuffer:DrawBlock - Number required (variable "y").');
		end
		if (type(width) ~= 'number') then
			error('VideoBuffer:DrawBlock - Number required (variable "width").');
		end
		if (type(height) ~='number') then
			error('VideoBuffer:DrawBlock - Number required (variable "height").');
		end

		local toWrite = ' ';
		if (symbol ~= nil) then
			toWrite = string.sub(symbol, 1, 1);
		end
		for i = y, height + y - 1 do
			for j = x, width + x - 1 do
				if (isOnScreen(j, i)) then
					pixels[i][j]:SetBackgroundColor(color);
					pixels[i][j]:SetTextColor(currentTextColor);
					pixels[i][j]:SetSymbol(toWrite);
				end
			end
		end
	end

	this.SetColorParameters = function(_, textColor, newBackgroundColor)
		currentBackgroundColor = newBackgroundColor;
		currentTextColor = textColor;
	end

	this.SetCursorBlink = function(_, value)
		cursorBlink = value;
	end

	this.Write = function(_, value)
		if (type(value) ~= 'string') then
			error('VideoBuffer:Write - String required (variable "value").');
		end

		local newCursorX = cursorX;
		for i = 1, string.len(value) do
			if (cursorY >= 1 and cursorY <= screenHeight) then
				local pixel = pixels[cursorY][cursorX + i - 1];
				pixel:SetBackgroundColor(currentBackgroundColor);
				pixel:SetTextColor(currentTextColor);
				pixel:SetSymbol(string.sub(value, i, i));
				newCursorX = newCursorX + 1;
			end
		end
		cursorX = newCursorX;
	end

	this.WriteAt = function(_, x, y, value)
		if (type(x) ~= 'number') then
			error('VideoBuffer:WriteAt - Number required (variable "x").');
		end
		if (type(y) ~='number') then
			error('VideoBuffer:WriteAt - Number required (variable "y").');
		end
		if (type(value) ~= 'string') then
			error('VideoBuffer:WriteAt - String required (variable "value").');
		end

		for i = 1, string.len(value) do
			if (isOnScreen(x + i - 1, y)) then
				local pixel = pixels[y][x + i - 1];
				pixel:SetBackgroundColor(currentBackgroundColor);
				pixel:SetTextColor(currentTextColor);
				pixel:SetSymbol(string.sub(value, i, i));
			end
		end
	end

	this.Clear = function(_)
		currentBackgroundColor = colors.black;
		currentTextColor = colors.white;
		for i = 1,screenHeight do
			for j = 1,screenWidth do
				pixels[i][j]:Clear();
			end
		end
	end

	this.Draw = function(_)
		term.setCursorBlink(false);
		for i = 1, screenHeight do
			for j = 1, screenWidth do
				pixels[i][j]:DrawAt(j, i);
			end
		end
		term.setCursorPos(realCursorX, realCursorY);
		term.setCursorBlink(cursorBlink);
		this:Clear();
	end
end)
VideoBuffer = Class(function(this)
	this.ClassName = 'VideoBuffer';

	local backgroundColor = {};
	local currentBackgroundColor = colors.black;
	local currentTextColor = colors.white;
	local textColor = {};
	local text = {};
	local cursorX = 1;
	local cursorY = 1;
	local realCursorX = 1;
	local realCursorY = 1;
	local cursorBlink = false;

	local screenWidth, screenHeight = term.getSize();
	for i = 1, screenHeight do
		backgroundColor[i] = {};
		textColor[i] = {};
		text[i] = {};
		for j = 1, screenWidth do
			backgroundColor[i][j] = colors.black;
			textColor[i][j] = colors.white;
			text[i][j] = '';
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
			backgroundColor[y][x] = color;
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
					backgroundColor[i][j] = color;
					textColor[i][j] = currentTextColor;
					text[i][j] = toWrite;
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

	this.Write = function(_, string)
		if (type(string) ~= 'string') then
			error('VideoBuffer:Write - String required (variable "string").');
		end

		local newCursorX = cursorX;
		for i = 1, string.len(string) do
			if (cursorY >= 1 and cursorY <= screenHeight) then
				backgroundColor[cursorY][cursorX + i - 1] = currentBackgroundColor;
				textColor[cursorY][cursorX + i - 1] = currentTextColor;
				text[cursorY][cursorX + i - 1] = string.sub(string, i, i);
				newCursorX = newCursorX + 1;
			end
		end
		cursorX = newCursorX;
	end

	this.WriteAt = function(_, x, y, string)
		if (type(x) ~= 'number') then
			error('VideoBuffer:WriteAt - Number required (variable "x").');
		end
		if (type(y) ~='number') then
			error('VideoBuffer:WriteAt - Number required (variable "y").');
		end
		if (type(string) ~= 'string') then
			error('VideoBuffer:WriteAt - String required (variable "string").');
		end

		for i = 1, string.len(string) do
			if (y >= 1 and y <= screenHeight) then
				backgroundColor[y][x + i - 1] = currentBackgroundColor;
				textColor[y][x + i - 1] = currentTextColor;
				text[y][x + i - 1] = string.sub(string, i, i);
			end
		end
	end

	this.Clear = function(_)
		currentBackgroundColor = colors.black;
		currentTextColor = colors.white;
		for i = 1,screenHeight do
			backgroundColor[i] = {};
			textColor[i] = {};
			text[i] = {};
			for j = 1,screenWidth do
				backgroundColor[i][j] = colors.black;
				textColor[i][j] = colors.white;
				text[i][j] = '';
			end
		end
	end

	this.Draw = function(_)
		term.setCursorBlink(false);
		for i = 1, screenHeight do
			for j = 1, screenWidth do
				if (text[i][j] == '') then
					paintutils.drawPixel(j, i, backgroundColor[i][j]);
				else
					term.setTextColor(textColor[i][j]);
					term.setBackgroundColor(backgroundColor[i][j]);
					term.setCursorPos(j, i);
					term.write(text[i][j]);
				end
			end
		end
		term.setCursorPos(realCursorX, realCursorY);
		term.setCursorBlink(cursorBlink);
		this:Clear();
	end
end)
local Pixel = Classes.System.Graphics.Pixel;

Classes.System.Graphics.Canvas = Class(Object, function(this, _dX, _dY, _width, _height, _anchor)
	Object.init(this, 'Canvas');

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local pixels;
	local currentBackgroundColor;
	local currentTextColor;
	local cursorColor;
	local cursorX;
	local cursorY;
	local realCursorX;
	local realCursorY;
	local cursorBlink;

	local x;
	local y;
	local dX;
	local dY;
	local width;
	local height;
	local anchor;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this.GetX()
		return x;
	end

	function this.GetY()
		return y;
	end

	local function updateSize()
		for i = 1, height do
			if (pixels[i] == nil) then
				pixels[i] = {};
			end
			for j = 1, width do
				if (pixels[i][j] == nil) then
					pixels[i][j] = Pixel();
				end
			end
		end
	end

	function this.GetWidth()
		return width;
	end

	function this.SetWidth(_, _value)
		width = _value;
		updateSize();
	end

	function this.GetHeight()
		return height;
	end

	function this.SetHeight(_, _value)
		height = _value;
		updateSize();
	end

	function this.SetRealCursorPos(_, _x, _y)
		if (type(_x) ~= 'number') then
			error('Canvas.SetRealCursorPos [x]: Number expected, got '..type(_x)..'.');
		end
		if (type(_y) ~= 'number') then
			error('Canvas.SetRealCursorPos [y]: Number expected, got '..type(_y)..'.');
		end	

		realCursorX = _x;
		realCursorY = _y;
	end

	function this.GetCursorPos()
		return cursorX, cursorY;
	end

	function this.SetCursorPos(_, _x, _y)
		if (type(_x) ~= 'number') then
			error('Canvas.SetCursorPos [x]: Number expected, got '..type(_x)..'.');
		end
		if (type(_y) ~= 'number') then
			error('Canvas.SetCursorPos [y]: Number expected, got '..type(_y)..'.');
		end	

		cursorX = _x;
		cursorY = _y;
	end

	function this.SetBackgroundColor(_, _value)
		if (type(_value) ~= 'number') then
			error('Canvas.SetBackgroundColor [value]: Number expected, got '..type(_value)..'.');
		end	

		currentBackgroundColor = _value;
	end

	function this.SetTextColor(_, _value)
		if (type(_value) ~= 'number') then
			error('Canvas.SetTextColor [value]: Number expected, got '..type(_value)..'.');
		end	

		currentTextColor = _value;
	end

	function this.SetColorParameters(_, _textColor, _backgroundColor)
		this:SetTextColor(_textColor);
		this:SetBackgroundColor(_backgroundColor);
	end

	function this.SetCursorBlink(_, _value)
		if (type(_value) ~= 'boolean') then
			error('Canvas.SetCursorBlink [value]: Boolean expected, got '..type(_value)..'.');
		end

		cursorBlink = _value;
	end

	function this.SetCursorColor(_, _value)
		if (type(_value) ~= 'number') then
			error('Canvas.SetCursorColor [value]: Number expected, got '..type(_value)..'.');
		end

		cursorColor = _value;
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function isOnCanvas(_x, _y)
		return (_x >= 1 and _x <= width and _y >= 1 and _y <= height);
	end

	function this.Scroll(_, _value)
		for i = 1, _value do
			for j = 2, height do
				pixels[j - 1] = pixels[j];
			end
			pixels[height] = {};
			for j = 1, width do
				pixels[height][j] = Pixel();
			end
		end
	end

	function this.SetPixelColor(_, _x, _y, _color)
		if (type(_x) ~= 'number') then
			error('Canvas.SetPixelColor [x]: Number expected, got '..type(_x)..'.');
		end
		if (type(_y) ~= 'number') then
			error('Canvas.SetPixelColor [y]: Number expected, got '..type(_y)..'.');
		end	
		if (type(_color) ~= 'number') then
			error('Canvas.SetPixelColor [color]: Number expected, got '..type(_color)..'.');
		end	

		if (isOnCanvas(_x, _y)) then
			pixels[_y][_x]:SetBackgroundColor(_color);
		end
	end

	function this.DrawBlock(_, _x, _y, _width, _height, _color, _symbol)
		if (type(_x) ~= 'number') then
			error('Canvas.DrawBlock [x]: Number expected, got '..type(_x)..'.');
		end
		if (type(_y) ~= 'number') then
			error('Canvas.DrawBlock [y]: Number expected, got '..type(_y)..'.');
		end	
		if (type(_width) ~= 'number') then
			error('Canvas.DrawBlock [width]: Number expected, got '..type(_width)..'.');
		end
		if (type(_height) ~= 'number') then
			error('Canvas.DrawBlock [height]: Number expected, got '..type(_height)..'.');
		end
		if (type(_color) ~= 'number') then
			error('Canvas.DrawBlock [color]: Number expected, got '..type(_color)..'.');
		end	
		if (_symbol ~= nil and type(_symbol) ~= 'string') then
			error('Canvas.DrawBlock [symbol]: String or nil expected, got '..type(_symbol)..'.');
		end

		local toWrite = ' ';
		if (_symbol ~= nil) then
			toWrite = string.sub(_symbol, 1, 1);
		end
		for i = _y, _height + _y - 1 do
			for j = _x, _width + _x - 1 do
				if (isOnCanvas(j, i)) then
					pixels[i][j]:SetBackgroundColor(_color);
					pixels[i][j]:SetTextColor(currentTextColor);
					pixels[i][j]:SetSymbol(toWrite);
				end
			end
		end
	end

	function this.Write(_, _value)
		if (type(_value) ~= 'string') then
			error('Canvas.Write [color]: String expected, got '..type(_value)..'.');
		end

		local newCursorX = cursorX;
		for i = 1, string.len(_value) do
			if (isOnCanvas(cursorX + i - 1, cursorY)) then
				local pixel = pixels[cursorY][cursorX + i - 1];
				pixel:SetBackgroundColor(currentBackgroundColor);
				pixel:SetTextColor(currentTextColor);
				pixel:SetSymbol(string.sub(_value, i, i));
				newCursorX = newCursorX + 1;
			end
		end
		cursorX = newCursorX;
	end

	function this.WriteAt(_, _x, _y, _value)
		if (type(_x) ~= 'number') then
			error('Canvas.WriteAt [x]: Number expected, got '..type(_x)..'.');
		end
		if (type(_y) ~= 'number') then
			error('Canvas.WriteAt [y]: Number expected, got '..type(_y)..'.');
		end
		if (type(_value) ~= 'string') then
			error('Canvas.WriteAt [color]: String expected, got '..type(_value)..'.');
		end

		for i = 1, string.len(_value) do
			if (isOnCanvas(_x + i - 1, _y)) then
				local pixel = pixels[_y][_x + i - 1];
				pixel:SetBackgroundColor(currentBackgroundColor);
				pixel:SetTextColor(currentTextColor);
				pixel:SetSymbol(string.sub(_value, i, i));
			end
		end
	end

	function this.GetCoordinates(_, _x, _y)
		local realX = x + _x - 1;
		local realY = y + _y - 1;
		return realX, realY;
	end

	function this.Clear()
		currentBackgroundColor = colors.black;
		currentTextColor = colors.white;
		cursorBlink = false;
		for i = 1, height do
			for j = 1, width do
				pixels[i][j]:Clear();
			end
		end
	end

	function this.ClearLine()
		for i = 1, width do
			pixels[cursorY][i]:Clear();
		end
	end

	function this.SetPixel(_, _x, _y, _pixel)
		if (isOnCanvas(_x, _y)) then
			local pixel = pixels[_y][_x];
			pixel:SetBackgroundColor(_pixel:GetBackgroundColor());
			pixel:SetTextColor(_pixel:GetTextColor());
			pixel:SetSymbol(_pixel:GetSymbol());
		end
	end

	local function draw(_videoBuffer)
		if (cursorBlink) then
			_videoBuffer:SetRealCursorPos(realCursorX + x - 1, realCursorY + y - 1);
			_videoBuffer:SetCursorColor(cursorColor);
			_videoBuffer:SetCursorBlink(cursorBlink);
		end

		for i = 1, height do
			for j = 1, width do
				_videoBuffer:SetPixel(x + j - 1, y + i - 1, pixels[i][j]);
			end
		end
	end

	function this.Draw(_, _videoBuffer, _ownerX, _ownerY, _ownerWidth, _ownerHeight)
		if (type(_videoBuffer) ~= 'table' and _videoBuffer.GetClassName == nil and _videoBuffer:GetClassName() ~= 'VideoBuffer' and _videoBuffer:GetClassName() ~= 'Canvas') then
			error('Canvas.Draw [videoBuffer]: VideoBuffer expected, got '..type(_videoBuffer)..'.');
		end
		if (type(_ownerX) ~= 'number') then
			error('Canvas.Draw [ownerX]: Number expected, got'..type(_ownerX)..'.');
		end
		if (type(_ownerY) ~= 'number') then
			error('Canvas.Draw [ownerY]: Number expected, got'..type(_ownerY)..'.');
		end	
		if (type(_ownerWidth) ~= 'number') then
			error('Canvas.Draw [ownerWidth]: Number expected, got '..type(_ownerWidth)..'.');
		end
		if (type(_ownerHeight) ~= 'number') then
			error('Canvas.Draw [ownerHeight]: Number expected, got '..type(_ownerHeight)..'.');
		end
		
		if (anchor == 'left-top') then
			x = _ownerX + dX;
			y = _ownerY + dY;
		elseif (anchor == 'right-top') then
			x = _ownerX + _ownerWidth + dX;
			y = _ownerY + dY;
		elseif (anchor == 'left-bottom') then
			x = _ownerX + dX;
			y = _ownerY + _ownerHeight + dY;
		elseif (anchor == 'right-bottom') then
			x = _ownerX + _ownerWidth + dX;
			y = _ownerY + _ownerHeight + dY;
		end

		draw(_videoBuffer);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor(_dX, _dY, _width, _height, _anchor)
		if (type(_dX) ~= 'number') then
			error('Canvas.Constructor [dX]: Number expected, got '..type(_dX)..'.');
		end
		if (type(_dY) ~= 'number') then
			error('Canvas.Constructor [dY]: Number expected, got '..type(_dY)..'.');
		end
		if (type(_width) ~= 'number') then
			error('Canvas.Constructor [width]: Number expected, got '..type(_width)..'.');
		end
		if (type(_height) ~= 'number') then
			error('Canvas.Constructor [height]: Number expected, got '..type(_height)..'.');
		end
		if (type(_anchor) ~= 'string') then
			error('Canvas.Constructor [anchor]: String expected, got '..type(_anchor)..'.');
		end

		dX = _dX;
		dY = _dY;
		x = 1;
		y = 1;
		anchor = _anchor;
		width = _width;
		height = _height;

		pixels = {};
		for i = 1, height do
			pixels[i] = {};
			for j = 1, width do
				pixels[i][j] = Pixel();
			end
		end

		currentBackgroundColor = colors.black;
		currentTextColor = colors.white;
		cursorX = 1;
		cursorY = 1;
		realCursorX = 1;
		realCursorY = 1;
		cursorBlink = false;
		cursorColor = colors.white;
	end

	constructor(_dX, _dY, _width, _height, _anchor);
end)
local function scrollUpClick(params)
	params[1]:ScrollUp();
end

local function scrollDownClick(params)
	params[1]:ScrollDown();
end

VerticalScrollBar = Class(Component, function(this, _minValue, _maxValue, height, barColor, rollerColor, dX, dY, anchorType)
	Component.init(this, dX, dY, anchorType);

	local maxValue = _maxValue;
	local minValue = _minValue;

	if (minValue > maxValue) then
		error('VerticalScrollBar: Constructor - Invalid values. minValue must be less then maxValue.');
	end

	this.Height = height;
	local value = minValue;
	this.BarColor = barColor;
	this.RollerColor = rollerColor;

	local scrollUpButton = Button('^', nil, nil, 0, 0, 'left-top');
	scrollUpButton.OnClick = scrollUpClick;
	scrollUpButton.OnClickParams = { this };

	local scrollDownButton = Button('v', nil, nil, 0, -1, 'left-bottom');
	scrollDownButton.OnClick = scrollDownClick;
	scrollDownButton.OnClickParams = { this };

	local getRollerY = function()
		local rollerY = this.Y + 1 + math.floor((value/(maxValue - minValue))*(this.Height - 3));
		if (value == minValue) then
			rollerY = this.Y + 1;
		elseif (value == maxValue) then
			rollerY = this.Y + this.Height - 2;
		end
		return rollerY;
	end

	this._draw = function(videoBuffer, x, y)
		local colorConfiguration = System:GetColorConfiguration();
		if (barColor == nil) then
			this.BarColor = colorConfiguration:GetColor('SystemButtonsTextColor');
		end
		if (rollerColor == nil) then
			this.RollerColor = colorConfiguration:GetColor('WindowBorderColor');
		end

		this.X = x;
		this.Y = y;
		videoBuffer:SetTextColor(colorConfiguration:GetColor('SystemButtonsColor'));
		videoBuffer:DrawBlock(this.X, this.Y, 1, this.Height, this.BarColor, '|');
		scrollDownButton:Draw(videoBuffer, this.X, this.Y, 1, this.Height);
		scrollUpButton:Draw(videoBuffer, this.X, this.Y, 1, this.Height);

		local rollerY = getRollerY();
		videoBuffer:SetPixelColor(this.X, rollerY, this.RollerColor);
	end

	local checkValue = function()
		if (value > maxValue) then
			value = maxValue;
		end
		if (value < minValue) then
			value = minValue;
		end
	end

	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		if (scrollUpButton:ProcessLeftClickEvent(cursorX, cursorY)) then
			return true;
		end
		if (scrollDownButton:ProcessLeftClickEvent(cursorX, cursorY)) then
			return true;
		end

		if (cursorX == this.X and cursorY >= this.Y and cursorY <= this.Y + this.Height - 1) then
			local position = cursorY - this.Y + 1;
			local newValuePersent = (position/this.Height);
			value = math.floor((maxValue - minValue)*newValuePersent);
			checkValue();
			return true;
		end

		return false;
	end

	this.GetValue = function(_)
		return value;
	end

	this.SetValue = function(_, newValue)
		value = newValue;
		checkValue();
	end

	this.SetMaxValue = function(_, _maxValue)
		maxValue = _maxValue;
		checkValue();
	end

	this.SetMinValue = function(_, _minValue)
		minValue = _minValue;
		checkValue();
	end

	this.ScrollUp = function(_)
		value = value - 1;
		checkValue();
	end

	this.ScrollDown = function(_)
		value = value + 1;
		checkValue();
	end
end)
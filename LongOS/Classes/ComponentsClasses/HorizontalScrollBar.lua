local function scrollLeftClick(params)
	params[1]:ScrollLeft();
end

local function scrollRightClick(params)
	params[1]:ScrollRight();
end

HorizontalScrollBar = Class(Component, function(this, _minValue, _maxValue, width, barColor, rollerColor, dX, dY, anchorType)
	Component.init(this, dX, dY, anchorType);

	this.GetClassName = function()
		return 'HorizontalScrollBar';
	end

	local maxValue = _maxValue;
	local minValue = _minValue;

	if (minValue > maxValue) then
		error('HorizontalScrollBar: Constructor - Invalid values. minValue must be less then maxValue.');
	end

	this.Width = width;
	local value = minValue;
	this.BarColor = barColor;
	this.RollerColor = rollerColor;

	local scrollLeftButton = Button('<', nil, nil, 0, 0, 'left-top');
	scrollLeftButton.OnClick = scrollLeftClick;
	scrollLeftButton.OnClickParams = { this };

	local scrollRightButton = Button('>', nil, nil, -1, 0, 'right-top');
	scrollRightButton.OnClick = scrollRightClick;
	scrollRightButton.OnClickParams = { this };

	local getRollerX = function()
		local rollerX = this.X + 1 + math.floor((value/(maxValue - minValue))*(this.Width - 3));
		if (value == minValue) then
			rollerX = this.X + 1;
		elseif (value == maxValue) then
			rollerX = this.X + this.Width - 2;
		end
		return rollerX;
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
		videoBuffer:DrawBlock(this.X, this.Y, this.Width, 1, this.BarColor, '-');
		scrollLeftButton:Draw(videoBuffer, this.X, this.Y, this.Width, 1);
		scrollRightButton:Draw(videoBuffer, this.X, this.Y, this.Width, 1);

		local rollerX = getRollerX();
		videoBuffer:SetPixelColor(rollerX, this.Y, this.RollerColor);
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
		if (scrollLeftButton:ProcessLeftClickEvent(cursorX, cursorY)) then
			return true;
		end
		if (scrollRightButton:ProcessLeftClickEvent(cursorX, cursorY)) then
			return true;
		end

		if (cursorY == this.Y and cursorX >= this.X and cursorX <= this.X + this.Width - 1) then
			local position = cursorX - this.X + 1;
			local newValuePersent = (position/this.Width);
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

	this.ScrollLeft = function(_)
		value = value - 1;
		checkValue();
	end

	this.ScrollRight = function(_)
		value = value + 1;
		checkValue();
	end
end)
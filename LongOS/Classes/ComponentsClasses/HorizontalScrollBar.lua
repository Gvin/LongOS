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

	local scrollLeftButtonClick = function(sender, eventArgs)
		this:ScrollLeft();
	end

	local scrollLeftButton = Button('<', nil, nil, 0, 0, 'left-top');
	scrollLeftButton:SetOnClick(scrollLeftButtonClick);

	local scrollRightButtonClick = function(sender, eventArgs)
		this:ScrollRight();
	end

	local scrollRightButton = Button('>', nil, nil, -1, 0, 'right-top');
	scrollRightButton:SetOnClick(scrollRightButtonClick);

	local getRollerX = function(x)
		local rollerX = x + 1 + math.floor((value/(maxValue - minValue))*(this.Width - 3));
		if (value == minValue) then
			rollerX = x + 1;
		elseif (value == maxValue) then
			rollerX = x + this.Width - 2;
		end
		if (value ~= maxValue and (rollerX == x + this.Width - 2) and this.Width > 4) then
			rollerX = x + this.Width - 3;
		end
		if (value ~= minValue and (rollerX == x + 1) and this.Width > 4) then
			rollerX = x + 2;
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

		this.X, this.Y = videoBuffer:GetCoordinates(x, y);

		videoBuffer:SetTextColor(colorConfiguration:GetColor('SystemButtonsColor'));
		videoBuffer:DrawBlock(x, y, this.Width, 1, this.BarColor, '-');
		scrollLeftButton:Draw(videoBuffer, x, y, this.Width, 1);
		scrollRightButton:Draw(videoBuffer, x, y, this.Width, 1);

		local rollerX = getRollerX(x);
		videoBuffer:SetPixelColor(rollerX, y, this.RollerColor);
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
			if (cursorX == this.X + 1) then
				this:SetValue(minValue);
				return true;
			end
			if (cursorX == this.X + this.Width - 2) then
				this:SetValue(maxValue);
				return true;
			end
			local position = cursorX - this.X + 1;
			local newValuePersent = (position/this.Width);
			value = math.floor((maxValue - minValue)*newValuePersent);
			checkValue();
			return true;
		end

		return false;
	end

	this.ProcessMouseScrollEvent = function(_, direction, cursorX, cursorY)
		if (this:Contains(cursorX, cursorY)) then
			if (direction < 0) then
				this:ScrollLeft();
			else
				this:ScrollRight();
			end
			return true;
		end
		return false;
	end

	this.Contains = function(_, x, y)
		return (y == this.Y and x >= this.X and x <= this.X + this.Width - 1);
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
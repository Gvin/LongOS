ProgressBar = Class(Component, function(this, _minValue, _maxValue, width, filledColor, emptyColor, dX, dY, anchorType)
	Component.init(this, dX, dY, anchorType);

	this.GetClassName = function()
		return 'ProgressBar';
	end

	local maxValue = _maxValue;
	local minValue = _minValue;

	if (minValue > maxValue) then
		error('ProgressBar: Constructor - Invalid values. minValue must be less then maxValue.');
	end

	local value = minValue;

	this.Width = width;
	this.FilledColor = filledColor;
	this.EmptyColor = emptyColor;
	this.TextColor = System:GetSystemColor('SystemLabelsTextColor');
	this.ShowPersent = false;

	this._draw = function(videoBuffer, x, y)
		this.X = x;
		this.Y = y;
		videoBuffer:DrawBlock(this.X, this.Y, this.Width, 1, this.EmptyColor);
		local filled = math.floor(this.Width*value/(maxValue - minValue));
		videoBuffer:DrawBlock(this.X, this.Y, filled, 1, this.FilledColor);

		local persent = math.floor(value/(maxValue - minValue)*100)..'%';
		local textPosition = this.X + math.floor(this.Width*50/(maxValue - minValue)) - 2;
		if (this.ShowPersent) then
			videoBuffer:SetColorParameters(this.TextColor, this.EmptyColor);
			videoBuffer:WriteAt(textPosition, this.Y, persent);
		end
	end

	local checkValue = function()
		if (value > maxValue) then
			value = maxValue;
		end
		if (value < minValue) then
			value = minValue;
		end
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
end)
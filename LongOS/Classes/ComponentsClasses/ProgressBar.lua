local Component = Classes.Components.Component;


Classes.Components.ProgressBar = Class(Component, function(this, _minValue, _maxValue, _width, _dX, _dY, _anchorType)
	Component.init(this, _dX, _dY, _anchorType);

	this.GetClassName = function()
		return 'ProgressBar';
	end

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local maxValue;
	local minValue;
	local value;


	local width;

	local filledColor;
	local emptyColor;
	local textColor;

	local showPersent;



	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function checkValue()
		if (value > maxValue) then
			value = maxValue;
		end
		if (value < minValue) then
			value = minValue;
		end
	end


	
	function this:GetFilledColor()
		return filledColor;
	end

	function this:SetFilledColor(_filledColor)
		filledColor = _filledColor;
	end

	function this:GetEmptyColor()
		return emptyColor;
	end

	function this:SetEmptyColor(_emptyColor)
		emptyColor = _emptyColor;
	end

	function this:GetTextColor()
		return textColor;
	end

	function this:SetTextColor(_textColor)
		textColor = _textColor;
	end






	function this:GetShowPersent()
		return showPersent;
	end

	function this:SetShowPersent(_showPersent)
		showPersent = _showPersent;
	end


	function this:GetValue()
		return value;
	end

	function this:SetValue(_newValue)
		value = _newValue;
		checkValue();
	end

	function this:GetMaxValue()
		return maxValue;
	end

	function this:SetMaxValue(_maxValue)
		maxValue = _maxValue;
		checkValue();
	end

	function this:GetMinValue()
		return minValue;
	end

	function this:SetMinValue(_minValue)
		minValue = _minValue;
		checkValue();
	end

	function this:Draw(_videoBuffer, _x, _y)		

		

		_videoBuffer:DrawBlock(_x, _y, width, 1, emptyColor);
		local filled = math.floor(width*value/(maxValue - minValue));
		_videoBuffer:DrawBlock(_x, _y, filled, 1, filledColor);		

		if (showPersent) then			

			local persent = math.floor(value/(maxValue - minValue)*100)..'%';
			local textPosition = _x + math.floor(width*50/(maxValue - minValue)) - 3;

			for i=1,#persent do				
				if (textPosition - _x + 1) > filled then
					_videoBuffer:SetColorParameters(textColor,emptyColor);
				else
					_videoBuffer:SetColorParameters(textColor,filledColor);
				end
				
				_videoBuffer:WriteAt(textPosition, _y, string.sub(persent,i,i+1));
				textPosition = textPosition + 1;
			end
		end
		
	end



	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor(_minValue, _maxValue, _height, _filledColor, _emptyColor)
		if (type(_minValue) ~= 'number') then
			error(this:GetClassName()..'.Constructor [minValue]: Number expected, got '..type(_minValue)..'.');
		end
		if (type(_maxValue) ~= 'number') then
			error(this:GetClassName()..'.Constructor [maxValue]: Number expected, got '..type(_maxValue)..'.');
		end
		if (type(_width) ~= 'number') then
			error(this:GetClassName()..'.Constructor [width]: Number expected, got '..type(_width)..'.');
		end

		if (_minValue > _maxValue) then
			error(this:GetClassName()..'.Constructor [minValue]: Invalid values. minValue must be less then maxValue.');
		end

		maxValue = _maxValue;
		minValue = _minValue;		

		width = _width;
		local colorConfiguration = System:GetColorConfiguration();
		textColor = colorConfiguration:GetColor('SystemLabelsTextColor');
		filledColor = colorConfiguration:GetColor('ProgressBarFilledColor');
		emptyColor = colorConfiguration:GetColor('ProgressBarEmptyColor');
		value = minValue;		

		showPersent = false;

	end

	constructor(_minValue, _maxValue, _width);

end)
VerticalScrollBar = Class(Component, function(this, _minValue, _maxValue, _height, _barColor, _rollerColor, _dX, _dY, _anchorType)
	Component.init(this, _dX, _dY, _anchorType);

	function this.GetClassName()
		return 'VerticalScrollBar';
	end

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local maxValue;
	local minValue;

	local height;
	local value;
	local barColor;
	local rollerColor;

	local x;
	local y;

	local scrollUpButton;
	local scrollDownButton;

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

	function this.GetValue()
		return value;
	end

	function this.SetValue(_, _value)
		value = _value;
		checkValue();
	end

	function this.SetMaxValue(_, _value)
		maxValue = _value;
		checkValue();
	end

	function this.SetMinValue(_, _value)
		minValue = _value;
		checkValue();
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this.Contains(_, _x, _y)
		return (_x == x and _y >= y and _y <= y + height - 1);
	end

	function this.ScrollUp()
		this:SetValue(value - 1);
	end

	function this.ScrollDown()
		this:SetValue(value + 1);
	end

	local function getRollerY(_y)
		local rollerY = _y + 1 + math.floor((value/(maxValue - minValue))*(height - 3));
		if (value == minValue) then
			rollerY = _y + 1;
		elseif (value == maxValue) then
			rollerY = _y + height - 2;
		end
		if (value ~= maxValue and (rollerY == _y + height - 2) and height > 4) then
			rollerY = _y + height - 3;
		end
		if (value ~= minValue and (rollerY == _y + 1) and height > 4) then
			rollerY = _y + 2;
		end
		return rollerY;
	end

	function this._draw(_, _videoBuffer, _x, _y)
		x, y = _videoBuffer:GetCoordinates(_x, _y);
		
		local colorConfiguration = System:GetColorConfiguration();
		_videoBuffer:SetTextColor(colorConfiguration:GetColor('WindowBorderColor'));
		_videoBuffer:DrawBlock(_x, _y, 1, height, barColor, '|');
		scrollDownButton:Draw(_videoBuffer, _x, _y, 1, height);
		scrollUpButton:Draw(_videoBuffer, _x, _y, 1, height);

		local rollerY = getRollerY(_y);
		_videoBuffer:SetPixelColor(_x, rollerY, rollerColor);
	end

	function this.ProcessLeftClickEvent(_, _cursorX, _cursorY)
		if (scrollUpButton:ProcessLeftClickEvent(_cursorX, _cursorY)) then
			return true;
		end
		if (scrollDownButton:ProcessLeftClickEvent(_cursorX, _cursorY)) then
			return true;
		end

		if (this:Contains(_cursorX, _cursorY)) then
			if (_cursorY == y + 1) then
				this:SetValue(minValue);
				return true;
			end
			if (_cursorY == y + height - 2) then
				this:SetValue(maxValue);
				return true;
			end
			local position = _cursorY - y + 1;
			local newValuePersent = (position/height);
			this:SetValue(math.floor((maxValue - minValue)*newValuePersent));
			return true;
		end

		return false;
	end

	function this.ProcessMouseScrollEvent(_, _direction, _cursorX, _cursorY)
		if (this:Contains(_cursorX, _cursorY)) then
			if (_direction < 0) then
				this:ScrollUp();
			else
				this:ScrollDown();
			end
			return true;
		end
		return false;
	end

	local function scrollUpButtonClick(_sender, _eventArgs)
		this:ScrollUp();
	end

	local function scrollDownButtonClick(_sender, _eventArgs)
		this:ScrollDown();
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		scrollUpButton = Button('^', nil, nil, 0, 0, 'left-top');
		scrollUpButton:SetOnClick(scrollUpButtonClick);

		scrollDownButton = Button('v', nil, nil, 0, -1, 'left-bottom');
		scrollDownButton:SetOnClick(scrollDownButtonClick);
	end

	local function constructor(_minValue, _maxValue, _height, _barColor, _rollerColor)
		if (type(_minValue) ~= 'number') then
			error('VerticalScrollBar.Constructor [minValue]: Number expected, got '..type(_minValue)..'.');
		end
		if (type(_maxValue) ~= 'number') then
			error('VerticalScrollBar.Constructor [maxValue]: Number expected, got '..type(_maxValue)..'.');
		end
		if (type(_height) ~= 'number') then
			error('VerticalScrollBar.Constructor [height]: Number expected, got '..type(_height)..'.');
		end
		if (_barColor ~= nil and type(_barColor) ~= 'number') then
			error('VerticalScrollBar.Constructor [barColor]: Number expected, got '..type(_barColor)..'.');
		end
		if (_rollerColor ~= nil and type(_rollerColor) ~= 'number') then
			error('VerticalScrollBar.Constructor [rollerColor]: Number expected, got '..type(_rollerColor)..'.');
		end
		if (_minValue > _maxValue) then
			error('VerticalScrollBar.Constructor [minValue]: Invalid values. minValue must be less then maxValue.');
		end

		minValue = _minValue;
		maxValue = _maxValue;
		height = _height;
		value = minValue;
		barColor = _barColor;
		rollerColor = _rollerColor;

		if (barColor == nil) then
			local colorConfiguration = System:GetColorConfiguration();
			barColor = colorConfiguration:GetColor('SystemButtonsTextColor');
		end
		if (rollerColor == nil) then
			local colorConfiguration = System:GetColorConfiguration();
			rollerColor = colorConfiguration:GetColor('WindowBorderColor');
		end

		x = 0;
		y = 0;

		initializeComponents();
	end

	constructor(_minValue, _maxValue, _height, _barColor, _rollerColor);
end)
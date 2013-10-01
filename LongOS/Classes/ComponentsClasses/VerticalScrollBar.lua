local Button = Classes.Components.Button;
local Component = Classes.Components.Component;
local EventHandler = Classes.System.EventHandler;

Classes.Components.VerticalScrollBar = Class(Component, function(this, _minValue, _maxValue, _height, _barColor, _rollerColor, _dX, _dY, _anchorType)
	Component.init(this, _dX, _dY, _anchorType);

	function this:GetClassName()
		return 'VerticalScrollBar';
	end

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local maxValue;
	local minValue;

	local height;
	local value;
	local barColor;
	local rollerColor;

	local scrollUpButton;
	local scrollDownButton;

	local onValueChanged;

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

	local function invokeOnValueChangedEvent(_oldValue, _value)
		local eventArgs = {};
		eventArgs.ValueBefore = _oldValue;
		eventArgs.ValueAfter = _value;
		onValueChanged:Invoke(this, eventArgs);
	end

	function this:GetValue()
		return value;
	end

	function this:SetValue(_value)
		if (type(_value) ~= 'number') then
			error(this:GetClassName()..'.SetValue [value]: Number expected, got '..type(_value)..'.');
		end
		if (this:GetEnabled()) then
			local oldValue = value;

			value = _value;
			checkValue();

			if (value ~= oldValue) then
				invokeOnValueChangedEvent(oldValue, value);
			end
		end
	end

	function this:SetMaxValue(_value)
		if (type(_value) ~= 'number') then
			error(this:GetClassName()..'.SetMaxValue [value]: Number expected, got '..type(_value)..'.');
		end

		maxValue = _value;
		checkValue();
	end

	function this:SetMinValue(_value)
		if (type(_value) ~= 'number') then
			error(this:GetClassName()..'.SetMinValue [value]: Number expected, got '..type(_value)..'.');
		end

		minValue = _value;
		checkValue();
	end

	function this:GetHeight()
		return height;
	end

	function this:SetHeight(_value)
		if (type(_value) ~= 'number') then
			error(this:GetClassName()..'.SetHeight [value]: Number expected, got '..type(_value)..'.');
		end

		height = _value;
	end

	function this:AddOnValueChangedEventHandler(_value)
		onValueChanged:AddHandler(_value);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:ScrollUp()
		this:SetValue(value - 1);
	end

	function this:ScrollDown()
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

	function this:Draw(_videoBuffer, _x, _y)
		local colorConfiguration = System:GetColorConfiguration();
		_videoBuffer:SetTextColor(colorConfiguration:GetColor('WindowBorderColor'));
		_videoBuffer:DrawBlock(_x, _y, 1, height, barColor, '|');
		scrollDownButton:DrawBase(_videoBuffer, _x, _y, 1, height);
		scrollUpButton:DrawBase(_videoBuffer, _x, _y, 1, height);

		local rollerY = getRollerY(_y);
		_videoBuffer:SetPixelColor(_x, rollerY, rollerColor);
	end

	function this:ProcessLeftClickEvent(_cursorX, _cursorY)
		if (this:GetEnabled()) then
			if (scrollUpButton:ProcessLeftClickEventBase(_cursorX, _cursorY)) then
				return true;
			end
			if (scrollDownButton:ProcessLeftClickEventBase(_cursorX, _cursorY)) then
				return true;
			end

			if (this:Contains(_cursorX, _cursorY)) then
				if (_cursorY == this:GetY() + 1) then
					this:SetValue(minValue);
					return true;
				end
				if (_cursorY == this:GetY() + height - 2) then
					this:SetValue(maxValue);
					return true;
				end
				local position = _cursorY - this:GetY() + 1;
				local newValuePersent = (position/height);
				this:SetValue(math.floor((maxValue - minValue)*newValuePersent));
				return true;
			end
		end

		return false;
	end

	function this:ProcessMouseScrollEvent(_direction, _cursorX, _cursorY)
		if (this:GetEnabled() and this:Contains(_cursorX, _cursorY)) then
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
		scrollUpButton:AddOnClickEventHandler(scrollUpButtonClick);

		scrollDownButton = Button('v', nil, nil, 0, 0, 'left-bottom');
		scrollDownButton:AddOnClickEventHandler(scrollDownButtonClick);
	end

	local function constructor(_minValue, _maxValue, _height, _barColor, _rollerColor)
		if (type(_minValue) ~= 'number') then
			error(this:GetClassName()..'.Constructor [minValue]: Number expected, got '..type(_minValue)..'.');
		end
		if (type(_maxValue) ~= 'number') then
			error(this:GetClassName()..'.Constructor [maxValue]: Number expected, got '..type(_maxValue)..'.');
		end
		if (type(_height) ~= 'number') then
			error(this:GetClassName()..'.Constructor [height]: Number expected, got '..type(_height)..'.');
		end
		if (_barColor ~= nil and type(_barColor) ~= 'number') then
			error(this:GetClassName()..'.Constructor [barColor]: Number expected, got '..type(_barColor)..'.');
		end
		if (_rollerColor ~= nil and type(_rollerColor) ~= 'number') then
			error(this:GetClassName()..'.Constructor [rollerColor]: Number expected, got '..type(_rollerColor)..'.');
		end
		if (_minValue > _maxValue) then
			error(this:GetClassName()..'.Constructor [minValue]: Invalid values. minValue must be less then maxValue.');
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

		onValueChanged = EventHandler();

		initializeComponents();
	end

	constructor(_minValue, _maxValue, _height, _barColor, _rollerColor);
end)
local Button = Classes.Components.Button;
local Component = Classes.Components.Component;
local EventHandler = Classes.System.EventHandler;

HorizontalScrollBar = Class(Component, function(this, _minValue, _maxValue, _width, _barColor, _rollerColor, _dX, _dY, _anchorType)
	Component.init(this, _dX, _dY, _anchorType);

	function this:GetClassName()
		return 'HorizontalScrollBar';
	end

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local maxValue;
	local minValue;

	local width;
	local value;
	local barColor;
	local rollerColor;
	local enabled;

	local scrollRightButton;
	local scrollLeftButton;

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
			error('HorizontalScrollBar.SetValue [value]: Number expected, got '..type(_value)..'.');
		end
		if (enabled) then
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
			error('HorizontalScrollBar.SetMaxValue [value]: Number expected, got '..type(_value)..'.');
		end

		maxValue = _value;
		checkValue();
	end

	function this:SetMinValue(_value)
		if (type(_value) ~= 'number') then
			error('HorizontalScrollBar.SetMinValue [value]: Number expected, got '..type(_value)..'.');
		end

		minValue = _value;
		checkValue();
	end

	function this:GetWidth()
		return width;
	end

	function this:SetWidth(_value)
		if (type(_value) ~= 'number') then
			error('HorizontalScrollBar.SetWidth [value]: Number expected, got '..type(_value)..'.');
		end

		width = _value;
	end

	function this:GetEnabled()
		return enabled;
	end

	function this:SetEnabled(_value)
		if (type(_value) ~= 'boolean') then
			error('HorizontalScrollBar.SetEnabled [value]: Boolean expected, got '..type(_value)..'.');
		end

		enabled = _value;
	end

	function this:AddOnValueChangedEventHandler(_value)
		onValueChanged:AddHandler(_value);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:ScrollLeft()
		this:SetValue(value - 1);
	end

	function this:ScrollRight()
		this:SetValue(value + 1);
	end

	local function getRollerX(_x)
		local rollerX = _x + 1 + math.floor((value/(maxValue - minValue))*(width - 3));
		if (value == minValue) then
			rollerX = _x + 1;
		elseif (value == maxValue) then
			rollerX = _x + width - 2;
		end
		if (value ~= maxValue and (rollerX == _x + width - 2) and width > 4) then
			rollerX = _x + width - 3;
		end
		if (value ~= minValue and (rollerX == _x + 1) and width > 4) then
			rollerX = _x + 2;
		end
		return rollerX;
	end

	function this:_draw(_videoBuffer, _x, _y)
		local colorConfiguration = System:GetColorConfiguration();
		_videoBuffer:SetTextColor(colorConfiguration:GetColor('SystemButtonsColor'));
		_videoBuffer:DrawBlock(_x, _y, width, 1, barColor, '-');
		scrollLeftButton:Draw(_videoBuffer, _x, _y, width, 1);
		scrollRightButton:Draw(_videoBuffer, _x, _y, width, 1);

		local rollerX = getRollerX(_x);
		_videoBuffer:SetPixelColor(rollerX, _y, rollerColor);
	end

	function this:ProcessLeftClickEvent(_cursorX, _cursorY)
		if (enabled) then
			if (scrollLeftButton:ProcessLeftClickEvent(_cursorX, _cursorY)) then
				return true;
			end
			if (scrollRightButton:ProcessLeftClickEvent(_cursorX, _cursorY)) then
				return true;
			end

			if (this:Contains(_cursorX, _cursorY)) then
				if (_cursorX == this:GetX() + 1) then
					this:SetValue(minValue);
					return true;
				end
				if (_cursorX == this:GetX() + width - 2) then
					this:SetValue(maxValue);
					return true;
				end
				local position = _cursorX - this:GetX() + 1;
				local newValuePersent = (position/width);
				this:SetValue(math.floor((maxValue - minValue)*newValuePersent));
				return true;
			end
		end

		return false;
	end

	function this:ProcessMouseScrollEvent(_direction, _cursorX, _cursorY)
		if (enabled and this:Contains(_cursorX, _cursorY)) then
			if (_direction < 0) then
				this:ScrollLeft();
			else
				this:ScrollRight();
			end
			return true;
		end
		return false;
	end

	local function scrollLeftButtonClick(_sender, _eventArgs)
		this:ScrollLeft();
	end

	local function scrollRightButtonClick(_sender, _eventArgs)
		this:ScrollRight();
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		scrollLeftButton = Button('<', nil, nil, 0, 0, 'left-top');
		scrollLeftButton:AddOnClickEventHandler(scrollLeftButtonClick);

		scrollRightButton = Button('>', nil, nil, 0, 0, 'right-top');
		scrollRightButton:AddOnClickEventHandler(scrollRightButtonClick);
	end

	local function constructor(_minValue, _maxValue, _width, _barColor, _rollerColor)
		if (type(_minValue) ~= 'number') then
			error('HorizontalScrollBar.Constructor [minValue]: Number expected, got '..type(_minValue)..'.');
		end
		if (type(_maxValue) ~= 'number') then
			error('HorizontalScrollBar.Constructor [maxValue]: Number expected, got '..type(_maxValue)..'.');
		end
		if (type(_width) ~= 'number') then
			error('HorizontalScrollBar.Constructor [width]: Number expected, got '..type(_width)..'.');
		end
		if (_barColor ~= nil and type(_barColor) ~= 'number') then
			error('HorizontalScrollBar.Constructor [barColor]: Number expected, got '..type(_barColor)..'.');
		end
		if (_rollerColor ~= nil and type(_rollerColor) ~= 'number') then
			error('HorizontalScrollBar.Constructor [rollerColor]: Number expected, got '..type(_rollerColor)..'.');
		end
		if (_minValue > _maxValue) then
			error('HorizontalScrollBar.Constructor [minValue]: Invalid values. minValue must be less then maxValue.');
		end

		minValue = _minValue;
		maxValue = _maxValue;
		width = _width;
		value = minValue;
		barColor = _barColor;
		rollerColor = _rollerColor;
		enabled = true;

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

	constructor(_minValue, _maxValue, _width, _barColor, _rollerColor);
end)
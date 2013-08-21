local EventHandler = Classes.System.EventHandler;

CheckBox = Class(Classes.Components.Component, function(this, _backgroundColor, _textColor, _dX, _dY, _anchorType)
	Classes.Components.Component.init(this, _dX, _dY, _anchorType);

	function this:GetClassName()
		return 'CheckBox';
	end

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local enabled;
	local visible;
	local checked;

	local checkedSymbol;
	local textColor;
	local backgroundColor;

	local onCheckedChanged;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:GetCheckedSymbol()
		return checkedSymbol;
	end

	function this:SetCheckedSymbol(_value)
		if (type(_value) ~= 'string') then
			error('CheckBox.SetCheckedSymbol [value]: String expected, got '..type(_value)..'.');
		end

		checkedSymbol = string.sub(_value,1,1);
	end

	function this:GetBackgroundColor()
		return backgroundColor;
	end

	function this:SetBackgroundColor(_value)
		if (type(_value) ~= 'number') then
			error('CheckBox.SetBackgroundColor [value]: Number expected, got '..type(_value)..'.');
		end

		backgroundColor = _value;
	end

	function this:GetTextColor()
		return textColor;
	end

	function this:SetTextColor(_value)
		if (type(_value) ~= 'number') then
			error('CheckBox.SetTextColor [value]: Number expected, got '..type(_value)..'.');
		end

		textColor = _value;
	end

	function this:GetChecked()
		return checked;
	end

	function this:SetChecked(_value)
		if (type(_value) ~= 'boolean') then
			error('CheckBox.SetChecked [value]: Boolean expected, got '..type(_value)..'.');
		end
		checked = _value;
		local eventArgs = {}
		eventArgs.checked = Checked;
		onCheckedChanged:Invoke(this,eventArgs);
	end

	function this:GetEnabled()
		return enabled;
	end

	function this:SetEnabled(_value)
		if (type(_value) ~= 'boolean') then
			error('CheckBox.SetEnabled [value]: Boolean expected, got '..type(_value)..'.');
		end
		enabled = _value;
	end	

	function this:GetVisible()
		return visible;
	end

	function this:SetVisible(_value)
		if (type(_value) ~= 'boolean') then
			error('CheckBox.SetVisible [value]: Boolean expected, got '..type(_value)..'.');
		end

		visible = _value;
	end

	function this:AddOnCheckedChangedEventHandler(_value)
		onCheckedChanged:AddHandler(_value);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------
	

	------------------------------------------------------------------------------------------------------------------
	----- Events ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:_draw(_videoBuffer, _x, _y)
		if (this:GetVisible()) then
			_videoBuffer:SetColorParameters(this:GetTextColor(), this:GetBackgroundColor());			
			if (this:GetChecked()) then
				printText	= checkedSymbol;
			else 
				printText	= ' ';
			end
			_videoBuffer:WriteAt(_x, _y, printText);
		end		
	end

	function this:ProcessLeftClickEvent(_cursorX, _cursorY)
		if (not this:GetEnabled() or not this:GetVisible()) then 
			return false; 
		end

		if (this:Contains(_cursorX, _cursorY)) then
			this:SetChecked(not checked);
			return true;
		end
	end

	function this:ProcessDoubleClickEvent(_cursorX, _cursorY)
		if (not this:GetEnabled() or not this:GetVisible()) then 
			return false; 
		end

		if (this:Contains(_cursorX, _cursorY)) then
			this:SetChecked(not checked);
			return true;
		end
	end
	

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor(_backgroundColor, _textColor)
		if (_backgroundColor ~= nil and type(_backgroundColor) ~= 'number') then
			error('CheckBox.Constructor [backgroundColor]: Number or nil expected, got '..type(_backgroundColor)..'.');
		end
		if (_textColor ~= nil and type(_textColor) ~= 'number') then
			error('CheckBox.Constructor [textColor]: Number or nil expected, got '..type(_textColor)..'.');
		end
		local configuration = System:GetColorConfiguration();
		if (_backgroundColor == nil) then			
			backgroundColor = configuration:GetColor('SystemEditsBackgroundColor');
		end
		if (_textColor == nil) then			
			textColor = configuration:GetColor('SystemLabelsTextColor');
		end	
		this:SetEnabled(true);
		this:SetVisible(true);
		checked = false;
		checkedSymbol = 'X';
		onCheckedChanged = EventHandler();
	end

	constructor(_backgroundColor, _textColor);
end)
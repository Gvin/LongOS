local Component = Classes.Components.Component;
local EventHandler = Classes.System.EventHandler;

Edit = Class(Component, function(this, _width, _backgroundColor, _textColor, _dX, _dY, _anchorType)
	Component.init(this, _dX, _dY, _anchorType);
	
	function this.GetClassName()
		return 'Edit';
	end

	function this:ToString()
		return this:GetText();
	end

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local cursorPosition;

	local backgroundColor;
	local textColor;
	local text;
	local width;

	local focus;
	local enabled;

	local onTextChanged;
	local onFocus;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function invokeOnTextChangedEvent(_textBefore, _textAfter)
		local eventArgs = {};
		eventArgs.TextBefore = _textBefore;
		eventArgs.TextAfter = _textAfter;
		onTextChanged:Invoke(this, eventArgs);
	end

	function this.GetText()
		return text;
	end

	function this.SetText(_, _value)
		if (type(_value) ~= 'string') then
			error('Edit.SetText [value]: String expected, got '..type(_value)..'.');
		end

		local oldText = text;

		text = _value;
		cursorPosition = string.len(text);

		invokeOnTextChangedEvent(oldText, text);
	end

	function this.GetWidth()
		return width;
	end

	function this.SetWidth(_, _value)
		if (type(_value) ~= 'number') then
			error('Edit.SetWidth [value] Number expected, got '..type(_value)..'.');
		end

		width = _value;
	end

	function this.GetBackgroundColor()
		return backgroundColor;
	end

	function this.SetBackgroundColor(_, _value)
		if (type(_value) ~= 'number') then
			error('Edit.SetBackgroundColor [value]: Number expected, got '..type(_value)..'.');
		end

		backgroundColor = _value;
	end

	function this.GetTextColor()
		return textColor;
	end

	function this.SetTextColor(_, _value)
		if (type(_value) ~= 'number') then
			error('Edit.SetTextColor [value]: Number expected, got '..type(_value)..'.');
		end

		textColor = _value;
	end

	function this.GetFocus()
		return focus;
	end

	function this.SetFocus(_, _value)
		if (type(_value) ~= 'boolean') then
			error('Edit.SetFocus [value]: Boolean expected, got '..type(_value)..'.');
		end

		focus = _value;
		if (not enabled) then
			focus = false;
		end

		if (focus) then
			onFocus:Invoke(this, {});
		end
	end

	function this.GetEnabled()
		return enabled;
	end

	function this.SetEnabled(_, _value)
		if (type(_value) ~= 'boolean') then
			error('Edit.SetEnabled [value]: Boolean expected, got '..type(_value)..'.');
		end

		enabled = _value;
		if (not enabled) then
			focus = false;
		end
	end

	function this.AddOnFocusEventHadler(_, _value)
		onFocus:AddHadler(_value);
	end

	function this.AddOnTextChangedEventHandler(_, _value)
		onTextChanged:AddHadler(_value);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this.Clear()
		local oldText = text;

		this:SetText('');

		invokeOnTextChangedEvent(oldText, text);
	end

	function this._draw(_, _videoBuffer, _x, _y)
		_videoBuffer:DrawBlock(_x, _y, width, 1, backgroundColor);
		_videoBuffer:SetColorParameters(textColor, backgroundColor);

		local toPrint = text;

		if (cursorPosition > string.len(toPrint)) then
			cursorPosition = string.len(toPrint);
		end

		if (cursorPosition > width - 2) then
			toPrint = ''..string.sub(toPrint, cursorPosition - width + 2, cursorPosition);
		end

		if (string.len(toPrint) > width - 2) then
			toPrint = ''..string.sub(toPrint, 1, width - 1);
		end

		if (focus) then
			local realCursorPosition = cursorPosition;
			if (realCursorPosition > width - 1) then
				realCursorPosition = width - 1;
			end
			_videoBuffer:SetRealCursorPos(_x + realCursorPosition, _y);
			_videoBuffer:SetCursorBlink(true);
			_videoBuffer:SetCursorColor(textColor);
		end

		_videoBuffer:WriteAt(_x, _y, toPrint);
	end

	function this.ProcessLeftClickEvent(_, _cursorX, _cursorY)
		if (this:Contains(_cursorX, _cursorY)) then
			this:SetFocus(true);
		else
			this:SetFocus(false);
		end
	end

	local function processBackspaceKey()
		if (string.len(text) <= 1 and cursorPosition ~= 0) then
			local oldText = text;

			text = '';
			cursorPosition = 0;

			invokeOnTextChangedEvent(oldText, text);
		elseif (cursorPosition ~= 0) then
			local oldText = text;

			text = ''..string.sub(text, 1, cursorPosition - 1)..string.sub(text, cursorPosition + 1, string.len(text));
			cursorPosition = cursorPosition - 1;

			invokeOnTextChangedEvent(oldText, text);
		end
	end

	local function processDeleteKey()
		if (string.len(text) > cursorPosition) then
			local oldText = text;

			text = ''..string.sub(text, 1, cursorPosition)..string.sub(text, cursorPosition + 2, string.len(text));

			invokeOnTextChangedEvent(oldText, text);
		end
	end

	function this.ProcessKeyEvent(_, _key)
		if (enabled and focus) then
			local keyName = keys.getName(_key);
			if (keyName == 'backspace') then
				processBackspaceKey();
			elseif (keyName == 'delete') then
				processDeleteKey();
			elseif (keyName == 'right') then
				if (cursorPosition < string.len(text)) then
					cursorPosition = cursorPosition + 1;
				end
			elseif (keyName == 'left') then
				if (cursorPosition > 0) then
					cursorPosition = cursorPosition - 1;
				end
			elseif (keyName == 'home') then
				cursorPosition = 0;
			elseif (keyName == 'end') then
				cursorPosition = string.len(text);
			end
		end
	end

	function this.ProcessCharEvent(_, _char)
		if (enabled and focus) then
			local oldText = text;

			local textBefore = ''..string.sub(text, 1, cursorPosition);
			local textAfter = ''..string.sub(text, cursorPosition + 1, string.len(text));
			text = textBefore.._char..textAfter;
			cursorPosition = cursorPosition + 1;

			invokeOnTextChangedEvent(oldText, text);
		end
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor(_width, _backgroundColor, _textColor)
		if (_backgroundColor ~= nil and type(_backgroundColor) ~= 'number') then
			error('Edit.Constructor [backgroundColor] Number or nil expected, got '..type(_backgroundColor)..'.');
		end
		if (_textColor ~= nil and type(_textColor) ~= 'number') then
			error('Edit.Constructor [textColor] Number or nil expected, got '..type(_textColor)..'.');
		end
		if (type(_width) ~= 'number') then
			error('Edit.Constructor [width] Number expected, got '..type(_width)..'.');
		end

		cursorPosition = 0;
		backgroundColor = _backgroundColor;
		textColor = _textColor;
		text = '';
		width = _width;
		focus = false;
		enabled = true;

		local colorConfiguration = System:GetColorConfiguration();
		if (backgroundColor == nil) then
			backgroundColor = colorConfiguration:GetColor('SystemEditsBackgroundColor');
		end
		if (textColor == nil) then
			textColor = colorConfiguration:GetColor('SystemLabelsTextColor');
		end

		onTextChanged = EventHandler();
		onFocus = EventHandler();
	end

	constructor(_width, _backgroundColor, _textColor);
end)
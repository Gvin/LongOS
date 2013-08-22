local EventHandler = Classes.System.EventHandler;
local VerticalScrollBar = Classes.Components.VerticalScrollBar;

Classes.Components.ListBox = Class(Classes.Components.Component, function(this, _width, _height, _backgroundColor, _textColor, _dX, _dY, _anchorType)
	Classes.Components.Component.init(this, _dX, _dY, _anchorType);
	
	function this:GetClassName()
		return 'ListBox';
	end

	function this:ToString()
		return 'ListBox';

	end

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------
	
	local vScrollBar
	local componentsManager;	

	local items;	
	local selectedIndex;

	local backgroundColor;
	local textColor;
	local selectedBackgroundColor;
	local selectedTextColor;	
	local width;
	local height;

	local focus;
	local enabled;


	---Events
	
	local onSelectedIndexChanged;



	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:GetCount()
		return #items;
	end

	function this:GetSelectedItem()
		if (selectedIndex ~= -1 ) then
			return  items[selectedIndex];
		else
			return nil;
		end
	end

	function this:GetSelectedIndex()
		return selectedIndex;
	end	

	function this:SetSelectedIndex(_index)
		if (type(_index) ~= 'number') then
			error('ListBox.RemoveItemAt [index] Number expected, got '..type(_index)..'.');
		end		

		if (_index > #items) then
			error('ListBox.RemoveItemAt [index] Out of range, index = '.._index);
		end
		eventArgs = {}
		eventArgs['OldIndex'] = selectedIndex;
		selectedIndex = _index;
		eventArgs['NewIndex'] = selectedIndex;		
		onSelectedIndexChanged:Invoke(this, eventArgs);
	end	

	function this:GetItem(_index)
		if (type(_index) ~= 'number') then
			error('ListBox.GetItem [index] Number expected, got '..type(_index)..'.');
		end		
		if (_index > #items or _index < 1) then
			error('ListBox.GetItem [index] Out of range, index = '.._index);
		end
		return items[_index];
	end	


	function this:GetWidth()
		return width;
	end

	function this:SetWidth(_value)
		if (type(_value) ~= 'number') then
			error('ListBox.SetWidth [value] Number expected, got '..type(_value)..'.');
		end
		width = _value;
	end

	function this:GetHeight()
		return height;
	end

	function this:SetHeight(_value)
		if (type(_value) ~= 'number') then
			error('ListBox.SetHeight [value] Number expected, got '..type(_value)..'.');
		end
		height = _value;
	end

	function this:GetBackgroundColor()
		return backgroundColor;
	end

	function this:SetBackgroundColor(_value)
		if (type(_value) ~= 'number') then
			error('ListBox.SetBackgroundColor [value]: Number expected, got '..type(_value)..'.');
		end

		backgroundColor = _value;
	end

	function this:GetSelectedBackgroundColor()
		return selectedBackgroundColor;
	end

	function this:SetSelectedBackgroundColor(_value)
		if (type(_value) ~= 'number') then
			error('ListBox.SetSelectedBackgroundColor [value]: Number expected, got '..type(_value)..'.');
		end

		selectedBackgroundColor = _value;
	end

	function this.GetTextColor()
		return textColor;
	end

	function this:SetTextColor(_value)
		if (type(_value) ~= 'number') then
			error('ListBox.SetTextColor [value]: Number expected, got '..type(_value)..'.');
		end
		textColor = _value;
	end	

	function this:GetSelectedTextColor()
		return selectedTextColor;
	end

	function this:SetSelectedTextColor(_value)
		if (type(_value) ~= 'number') then
			error('ListBox.SetSelectedTextColor [value]: Number expected, got '..type(_value)..'.');
		end
		selectedTextColor = _value;
	end		

	function this:GetEnabled()
		return enabled;
	end

	function this:SetEnabled(_value)
		if (type(_value) ~= 'boolean') then
			error('ListBox.SetEnabled [value]: Boolean expected, got '..type(_value)..'.');
		end
		enabled = _value;	
		if (enabled == false) then
			this:SetSelectedIndex(-1);
		end	
	end

	function this:AddOnSelectedIndexChangedEventHandler(_value)
		onSelectedIndexChanged:AddHandler(_value);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:Clear()		
		items = {};
		selectedIndex = -1;	
		return true;	
	end

	function this:AddItem(_item)
		if (type(_item) ~= 'string') then
			error('ListBox.AddItem [item] String expected, got '..type(_item)..'.');
		end		
		table.insert(items,_item);

		if (#items > height) then
			vScrollBar:SetMaxValue(#items - height);		
		end
	end

	function this:RemoveItemAt(_index)
		if (type(_index) ~= 'number') then
			error('ListBox.RemoveItemAt [index] Number expected, got '..type(_index)..'.');
		end		

		if (_index > #items or _index < 1) then
			error('ListBox.RemoveItemAt [index] Out of range, index = '.._index);
		end
		table.remove(items,_index);
		if (_index == selectedIndex) then
			this:SetSelectedIndex(-1);
		elseif (_index < selectedIndex) then
			this:SetSelectedIndex(selectedIndex - 1);			
		end

		if ( #items >= height) then
			vScrollBar:SetMaxValue(#items - height);		
		end
	end

	------------------------------------------------------------------------------------------------------------------
	----- Events ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:_draw(_videoBuffer, _x, _y)
		_videoBuffer:DrawBlock(_x, _y, width, height, backgroundColor);	
		vScrollBar:Draw(_videoBuffer, _x, _y, width, height);
		_videoBuffer:SetColorParameters(textColor, backgroundColor);		
		local i = 0;
		while i<#items and i<height do
			local index = i+1 + vScrollBar:GetValue()
			if (index == selectedIndex) then
				_videoBuffer:SetColorParameters(selectedTextColor, selectedBackgroundColor);
				_videoBuffer:DrawBlock(_x, _y + i, width-1, 1, selectedBackgroundColor);	
			else
				_videoBuffer:SetColorParameters(textColor, backgroundColor);
			end
			if (items[index] ~= nil) then
				
				local text = items[index];
				if #text > width - 1 then
					text = string.sub(text,1,width - 3);
					text = text..'..'
				end
				_videoBuffer:WriteAt(_x, _y + i, text);
			end
			i = i + 1;
		end				
	end

	function this:ProcessLeftClickEvent(_cursorX, _cursorY)
		if (this:Contains(_cursorX, _cursorY) and this:GetEnabled()) then
			if (vScrollBar:ProcessLeftClickEvent(_cursorX, _cursorY)) then
				return true;
			end			
			local index = _cursorY - this:GetY() + 1 + vScrollBar:GetValue();
			
			if (index <= #items) then
				this:SetSelectedIndex(index);					
			end			
		end
	end	

	function this:ProcessMouseScrollEvent(_direction, _cursorX, _cursorY)
		if (this:Contains(_cursorX, _cursorY)) then
			if (_direction == -1) then
				vScrollBar:ScrollUp();
			else
				vScrollBar:ScrollDown();	
			end					
		end
	end

	function this:ProcessKeyEvent(_key)
		if (_key == 208) then
			if (selectedIndex < this:GetCount() and selectedIndex ~= -1) then
				this:SetSelectedIndex(selectedIndex + 1);				
				if ( (height + vScrollBar:GetValue()) < selectedIndex ) then					
					local scrollPos = selectedIndex - height	;					
					vScrollBar:SetValue(scrollPos);	
				elseif ( vScrollBar:GetValue() + 1 > selectedIndex ) then
					local scrollPos = selectedIndex - 1	;
					vScrollBar:SetValue(scrollPos);	
				end								
			end
		elseif (_key == 200) then
			if (selectedIndex > 1) then
				this:SetSelectedIndex(selectedIndex - 1);				
				if ( vScrollBar:GetValue() + 1 > selectedIndex ) then				
					local scrollPos = selectedIndex - 1	;
					vScrollBar:SetValue(scrollPos);
				elseif ( (height + vScrollBar:GetValue()) < selectedIndex ) then
					local scrollPos = selectedIndex - height	;					
					vScrollBar:SetValue(scrollPos);		
				end				
			end
		end
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	
	local function initializeComponents()
		vScrollBar = VerticalScrollBar(0, 0, height, nil, nil, 0, 0, 'right-top');		
	end

	local function constructor(_width, _height, _backgroundColor, _textColor)
		if (_backgroundColor ~= nil and type(_backgroundColor) ~= 'number') then
			error('ListBox.Constructor [backgroundColor] Number or nil expected, got '..type(_backgroundColor)..'.');
		end
		if (_textColor ~= nil and type(_textColor) ~= 'number') then
			error('ListBox.Constructor [textColor] Number or nil expected, got '..type(_textColor)..'.');
		end
		if (type(_width) ~= 'number') then
			error('ListBox.Constructor [width] Number expected, got '..type(_width)..'.');
		end
		if (type(_height) ~= 'number') then
			error('ListBox.Constructor [height] Number expected, got '..type(_height)..'.');
		end
		
		selectedIndex = -1;
		backgroundColor = _backgroundColor;
		textColor = _textColor;
		items = {};
		width = _width;	
		height = _height;	
		enabled = true;

		local colorConfiguration = System:GetColorConfiguration();
		if (backgroundColor == nil) then
			backgroundColor = colorConfiguration:GetColor('SystemEditsBackgroundColor');
		end
		if (textColor == nil) then
			textColor = colorConfiguration:GetColor('SystemLabelsTextColor');
		end		

		selectedBackgroundColor = colorConfiguration:GetColor('SelectedBackgroundColor');
		selectedTextColor = colorConfiguration:GetColor('SelectedTextColor');
		
		initializeComponents();

		onSelectedIndexChanged = EventHandler();
		
	end

	constructor(_width, _height,_backgroundColor, _textColor);
end)
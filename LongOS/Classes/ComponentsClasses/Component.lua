Component = Class(function(this, _dX, _dY, _anchorType)
	
	function this.GetClassName()
		return 'Component';
	end

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local dX;
	local dY;
	local anchorType;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this.GetdX()
		return dX;
	end

	function this.SetdX(_, _value)
		if (type(_value) ~= 'number') then
			error('Component.SetdX [value]: Number expected, got '..type(_value)..'.');
		end

		dX = _value;
	end

	function this.GetdY()
		return dY;
	end

	function this.SetdY(_, _value)
		if (type(_value) ~= 'number') then
			error('Component.SetdY [value]: Number expected, got '..type(_value)..'.');
		end

		dY = _value;
	end

	function this.GetAnchor()
		return anchorType;
	end

	function this.SetAnchor(_, _value)
		if (type(_value) ~= 'string') then
			error('Component.SetAnchor [value]: String expected, got '..type(_value)..'.');
		end
		if (_value ~= 'left-top' and _value ~= 'right-top' and _value ~= 'left-bottom' and _value ~= 'right-bottom') then
			error('Component.SetAnchor [value]: Invalid parameter value. Must be in range [left-top, right-top, left-bottom, right-bottom].');
		end

		anchorType = _value;
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this._draw(_, _videoBuffer, _x, _y)
	end

	function this.Draw(_, _videoBuffer, _ownerX, _ownerY, _ownerWidth, _ownerHeight)
		if (type(_ownerX) ~= 'number') then
			error('Component.Draw [ownerX]: Number expected, got '..type(_ownerX)..'.');
		end
		if (type(_ownerY) ~= 'number') then
			error('Component.Draw [ownerY]: Number expected, got '..type(_ownerY)..'.');
		end
		if (type(_ownerWidth) ~= 'number') then
			error('Component.Draw [ownerWidth]: Number expected, got '..type(_ownerWidth)..'.');
		end
		if (type(_ownerHeight) ~= 'number') then
			error('Component.Draw [ownerHeight]: Number expected, got '..type(_ownerHeight)..'.');
		end

		if (anchorType == 'left-top') then
			this:_draw(_videoBuffer, _ownerX + dX, _ownerY + dY);
		elseif (anchorType == 'right-top') then
			this:_draw(_videoBuffer, _ownerX + _ownerWidth + dX, _ownerY + dY);
		elseif (anchorType == 'left-bottom') then
			this:_draw(_videoBuffer, _ownerX + dX, _ownerY + _ownerHeight + dY);
		elseif (anchorType == 'right-bottom') then
			this:_draw(_videoBuffer, _ownerX + _ownerWidth + dX, _ownerY + _ownerHeight + dY);
		end
	end

	

	function this.ProcessLeftClickEvent(_, _cursorX, _cursorY)
		return false;
	end

	function this.ProcessKeyEvent(_, _key)
		return false;
	end

	function this.ProcessCharEvent(_, _char)
		return false;
	end

	function this.ProcessDoubleClickEvent(_, _cursorX, _cursorY)
		return false;
	end

	function this.ProcessMouseScrollEvent(_, _direction, _cursorX, _cursorY)
		return false;
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor(_dX, _dY, _anchorType)
		if (type(_dX) ~= 'number') then
			error('Component.Constructor [dX]: Number expected, got '..type(_dX)..'.');
		end
		if (type(_dY) ~= 'number') then
			error('Component.Constructor [dY]: Number expected, got '..type(_dY)..'.');
		end
		if (type(_anchorType) ~= 'string') then
			error('Component.Constructor [anchorType]: String expected, got '..type(_anchorType)..'.');
		end

		if (_anchorType ~= 'left-top' and _anchorType ~= 'right-top' and _anchorType ~= 'left-bottom' and _anchorType ~= 'right-bottom') then
			error('Component.Constructor [anchorType]: Invalid parameter value. Must be in range [left-top, right-top, left-bottom, right-bottom].');
		end

		dX = _dX;
		dY = _dY;
		anchorType = _anchorType;
	end

	constructor(_dX, _dY, _anchorType);
end)
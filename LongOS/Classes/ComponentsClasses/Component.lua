Classes.Components.Component = Class(Object, function(this, _dX, _dY, _anchorType)
	Object.init(this, 'Component');

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local dX;
	local dY;
	local x;
	local y;
	local anchorType;

	local visible;
	local enabled;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:GetdX()
		return dX;
	end

	function this:SetdX(_value)
		if (type(_value) ~= 'number') then
			error(this:GetClassName()..'.SetdX [value]: Number expected, got '..type(_value)..'.');
		end

		dX = _value;
	end

	function this:GetdY()
		return dY;
	end

	function this:SetdY(_value)
		if (type(_value) ~= 'number') then
			error(this:GetClassName()..'.SetdY [value]: Number expected, got '..type(_value)..'.');
		end

		dY = _value;
	end

	function this:GetAnchor()
		return anchorType;
	end

	function this:SetAnchor(_value)
		if (type(_value) ~= 'string') then
			error(this:GetClassName()..'.SetAnchor [value]: String expected, got '..type(_value)..'.');
		end
		if (_value ~= 'left-top' and _value ~= 'right-top' and _value ~= 'left-bottom' and _value ~= 'right-bottom') then
			error(this:GetClassName()..'.SetAnchor [value]: Invalid parameter value. Must be in range [left-top, right-top, left-bottom, right-bottom].');
		end

		anchorType = _value;
	end

	function this:GetWidth()
		return 1;
	end

	function this:GetHeight()
		return 1;
	end

	function this:GetX()
		return x;
	end

	function this:GetY()
		return y;
	end

	function this:GetVisible()
		return visible;
	end

	function this:SetVisible(_value)
		if (type(_value) ~= 'boolean') then
			error(this:GetClassName()..'.SetVisible [value]: Boolean expected, got '..type(_value)..'.');
		end

		visible = _value;
	end

	function this:GetEnabled()
		return enabled;
	end

	function this:SetEnabled(_value)
		if (type(_value) ~= 'boolean') then
			error(this:GetClassName()..'.SetEnabled [value]: Boolean expected, got '..type(_value)..'.');
		end

		enabled = _value;
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:Contains(_x, _y)
		if (type(_x) ~= 'number') then
			error(this:GetClassName()..'.Contains [x]: Number required, got '..type(_x)..'.');
		end
		if (type(_y) ~= 'number') then
			error(this:GetClassName()..'.Contains [y]: Number required, got '..type(_y)..'.');
		end

		return (_y >= this:GetY() and _y <= this:GetY() + this:GetHeight() - 1 and _x >= this:GetX() and _x <= this:GetX() + this:GetWidth() - 1);
	end

	function this:Draw(_videoBuffer, _x, _y)
	end

	function this:DrawBase(_videoBuffer, _ownerX, _ownerY, _ownerWidth, _ownerHeight)
		if (type(_ownerX) ~= 'number') then
			error(this:GetClassName()..'.Draw [ownerX]: Number expected, got '..type(_ownerX)..'.');
		end
		if (type(_ownerY) ~= 'number') then
			error(this:GetClassName()..'.Draw [ownerY]: Number expected, got '..type(_ownerY)..'.');
		end
		if (type(_ownerWidth) ~= 'number') then
			error(this:GetClassName()..'.Draw [ownerWidth]: Number expected, got '..type(_ownerWidth)..'.');
		end
		if (type(_ownerHeight) ~= 'number') then
			error(this:GetClassName()..'.Draw [ownerHeight]: Number expected, got '..type(_ownerHeight)..'.');
		end

		local altX = 0;
		local altY = 0;

		if (anchorType == 'left-top') then
			altX = _ownerX + dX;
			altY = _ownerY + dY;
		elseif (anchorType == 'right-top') then
			altX = _ownerX + _ownerWidth - dX - this:GetWidth();
			altY = _ownerY + dY;
		elseif (anchorType == 'left-bottom') then
			altX = _ownerX + dX;
			altY = _ownerY + _ownerHeight - dY - this:GetHeight();
		elseif (anchorType == 'right-bottom') then
			altX = _ownerX + _ownerWidth - dX - this:GetWidth();
			altY = _ownerY + _ownerHeight - dY - this:GetHeight();
		end

		x, y = _videoBuffer:GetCoordinates(altX, altY);

		if (this:GetVisible()) then
			this:Draw(_videoBuffer, altX, altY);
		end
	end

	function this:ProcessLeftClickEventBase(_cursorX, _cursorY)
		if (this:GetEnabled() and this:GetVisible()) then
			return this:ProcessLeftClickEvent(_cursorX, _cursorY);
		end

		return false;
	end

	function this:ProcessLeftClickEvent(_cursorX, _cursorY)
		return false;
	end

	function this:ProcessKeyEventBase(_key)
		if (this:GetEnabled() and this:GetVisible()) then
			return this:ProcessKeyEvent(_key);
		end

		return false;
	end

	function this:ProcessKeyEvent(_key)
		return false;
	end

	function this:ProcessCharEventBase(_char)
		if (this:GetEnabled() and this:GetVisible()) then
			return this:ProcessCharEvent(_char);
		end

		return false;
	end

	function this:ProcessCharEvent(_char)
		return false;
	end

	function this:ProcessDoubleClickEventBase(_cursorX, _cursorY)
		if (this:GetEnabled() and this:GetVisible()) then
			return this:ProcessDoubleClickEvent(_cursorX, _cursorY);
		end

		return false;
	end

	function this:ProcessDoubleClickEvent(_cursorX, _cursorY)
		return false;
	end

	function this:ProcessMouseScrollEventBase(_direction, _cursorX, _cursorY)
		if (this:GetEnabled() and this:GetVisible()) then
			return this:ProcessMouseScrollEvent(_direction, _cursorX, _cursorY);
		end

		return false;
	end

	function this:ProcessMouseScrollEvent(_direction, _cursorX, _cursorY)
		return false;
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor(_dX, _dY, _anchorType)
		if (type(_dX) ~= 'number') then
			error(this:GetClassName()..'.Constructor [dX]: Number expected, got '..type(_dX)..'.');
		end
		if (type(_dY) ~= 'number') then
			error(this:GetClassName()..'.Constructor [dY]: Number expected, got '..type(_dY)..'.');
		end
		if (type(_anchorType) ~= 'string') then
			error(this:GetClassName()..'.Constructor [anchorType]: String expected, got '..type(_anchorType)..'.');
		end

		if (_anchorType ~= 'left-top' and _anchorType ~= 'right-top' and _anchorType ~= 'left-bottom' and _anchorType ~= 'right-bottom') then
			error(this:GetClassName()..'.Constructor [anchorType]: Invalid parameter value. Must be in range [left-top, right-top, left-bottom, right-bottom].');
		end

		dX = _dX;
		dY = _dY;
		x = 0;
		y = 0;
		anchorType = _anchorType;

		enabled = true;
		visible = true;
	end

	constructor(_dX, _dY, _anchorType);
end)
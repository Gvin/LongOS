Component = Class(Object, function(this, _dX, _dY, _anchorType)
	Object.init(this, 'Component');

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local dX;
	local dY;
	local x;
	local y;
	local anchorType;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:GetdX()
		return dX;
	end

	function this:SetdX(_value)
		if (type(_value) ~= 'number') then
			error('Component.SetdX [value]: Number expected, got '..type(_value)..'.');
		end

		dX = _value;
	end

	function this:GetdY()
		return dY;
	end

	function this:SetdY(_value)
		if (type(_value) ~= 'number') then
			error('Component.SetdY [value]: Number expected, got '..type(_value)..'.');
		end

		dY = _value;
	end

	function this:GetAnchor()
		return anchorType;
	end

	function this:SetAnchor(_value)
		if (type(_value) ~= 'string') then
			error('Component.SetAnchor [value]: String expected, got '..type(_value)..'.');
		end
		if (_value ~= 'left-top' and _value ~= 'right-top' and _value ~= 'left-bottom' and _value ~= 'right-bottom') then
			error('Component.SetAnchor [value]: Invalid parameter value. Must be in range [left-top, right-top, left-bottom, right-bottom].');
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

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:Contains(_x, _y)
		if (type(_x) ~= 'number') then
			error('Component.Contains [x]: Number required, got '..type(_x)..'.');
		end
		if (type(_y) ~= 'number') then
			error('Component.Contains [y]: Number required, got '..type(_y)..'.');
		end

		return (_y >= this:GetY() and _y <= this:GetY() + this:GetHeight() - 1 and _x >= this:GetX() and _x <= this:GetX() + this:GetWidth() - 1);
	end

	function this:_draw(_videoBuffer, _x, _y)
	end

	function this:Draw(_videoBuffer, _ownerX, _ownerY, _ownerWidth, _ownerHeight)
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
		this:_draw(_videoBuffer, altX, altY);
	end

	function this:ProcessLeftClickEvent(_cursorX, _cursorY)
		return false;
	end

	function this:ProcessKeyEvent(_key)
		return false;
	end

	function this:ProcessCharEvent(_char)
		return false;
	end

	function this:ProcessDoubleClickEvent(_cursorX, _cursorY)
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
		x = 0;
		y = 0;
		anchorType = _anchorType;
	end

	constructor(_dX, _dY, _anchorType);
end)
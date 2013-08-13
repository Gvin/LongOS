Component = Class(function(this, _dX, _dY, _anchorType)
	
	this.GetClassName = function()
		return 'Component';
	end

	if (type(_anchorType) ~= 'string') then
		error('Component: Constructor - String required (variable "anchorType").');
	end
	if (type(_dX) ~= 'number') then
		error('Component: Constructor - Number required (variable "dX").');
	end
	if (type(_dY) ~= 'number') then
		error('Component: Constructor - Number required (variable "dY").');
	end
	
	this.dX = _dX;
	this.dY = _dY;
	
	if (_anchorType ~= 'left-top' and _anchorType ~= 'right-top' and _anchorType ~= 'left-bottom' and _anchorType ~= 'right-bottom') then
		error('Component: Constructor - Invalid parameter value. "anchorType" must be in range [left-top, right-top, left-bottom, right-bottom].');
	end

	local anchorType = _anchorType;

	this.SetAnchor = function(_, value)
		anchorType = value;
	end

	this._draw = function(videoBuffer, x, y)
	end

	this.Draw = function(_, videoBuffer, ownerX, ownerY, ownerWidth, ownerHeight)
		if (type(ownerX) ~= 'number') then
			error('Component: Draw - Number required (variable "ownerX").');
		end
		if (type(ownerY) ~= 'number') then
			error('Component: Draw - Number required (variable "ownerY").');
		end
		if (type(ownerWidth) ~= 'number') then
			error('Component: Draw - Number required (variable "ownerWidth").');
		end
		if (type(ownerHeight) ~= 'number') then
			error('Component: Draw - Number required (variable "ownerHeight").');
		end

		if (anchorType == 'left-top') then
			this._draw(videoBuffer, ownerX + this.dX, ownerY + this.dY);
		elseif (anchorType == 'right-top') then
			this._draw(videoBuffer, ownerX + ownerWidth + this.dX, ownerY + this.dY);
		elseif (anchorType == 'left-bottom') then
			this._draw(videoBuffer, ownerX + this.dX, ownerY + ownerHeight + this.dY);
		elseif (anchorType == 'right-bottom') then
			this._draw(videoBuffer, ownerX + ownerWidth + this.dX, ownerY + ownerHeight + this.dY);
		end
	end

	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		return false;
	end

	this.ProcessKeyEvent = function(_, key)
		return false;
	end

	this.ProcessCharEvent = function(_, char)
		return false;
	end

	this.ProcessDoubleClickEvent = function(_, cursorX, cursorY)
		return false;
	end

	this.ProcessMouseScrollEvent = function(_, direction, cursorX, cursorY)
		return false;
	end
end)
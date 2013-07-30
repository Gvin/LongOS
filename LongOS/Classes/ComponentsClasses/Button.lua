Button = Class(Component, function(this, text, backgroundColor, textColor, dX, dY, anchorType)
	Component.init(this, dX, dY, anchorType);
	
	this.GetClassName = function()
		return 'Button';
	end

	if (type(text) ~= 'string') then
		error('Button: Constructor - String required (variable "text").');
	end

	this.Text = text;
	this.BackgroundColor = backgroundColor;
	this.TextColor = textColor;

	this.OnClick = nil;
	this.OnClickParams = nil;
	this.Enabled = true;
	this.X = dX;
	this.Y = dY;

	this._draw = function(videoBuffer, x, y)
		local colorConfiguration = System:GetColorConfiguration();
		if (backgroundColor == nil) then
			this.BackgroundColor = colorConfiguration:GetColor('SystemButtonsColor');
		end
		if (textColor == nil) then
			this.TextColor = colorConfiguration:GetColor('SystemButtonsTextColor');
		end

		this.X = x;
		this.Y = y;
		videoBuffer:SetBackgroundColor(this.BackgroundColor);
		videoBuffer:SetTextColor(this.TextColor);
		videoBuffer:WriteAt(x, y, this.Text);
	end

	this.Contains = function(_, x, y)
		if (type(x) ~= 'number') then
			error('Button: Contains - Number required (variable "x").');
		end
		if (type(y) ~= 'number') then
			error('Button: Contains - Number required (variable "y").');
		end

		return (y == this.Y and x >= this.X and x <= this.X + string.len(this.Text) - 1);
	end

	local click = function()
		if (this.OnClick ~= nil) then
			if (type(this.OnClick) ~= 'function') then
				error('Button: click - Function required (variable "OnClick").');
			end
			this.OnClick(this.OnClickParams);
		end
	end

	local processClickEvent = function(cursorX, cursorY)
		if (type(cursorX) ~= 'number') then
			error('Button: ProcessClickEvent - Number required (variable "cursorX").');
		end
		if (type(cursorY) ~= 'number') then
			error('Button: ProcessClickEvent - Number required (variable "cursorY").');
		end

		if (not this.Enabled) then return false; end
		
		if (this:Contains(cursorX, cursorY)) then
			click();
			return true;
		end
		return false;
	end

	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		return processClickEvent(cursorX, cursorY);
	end

	this.ProcessDoubleClickEvent = function(_, cursorX, cursorY)
		return processClickEvent(cursorX, cursorY);
	end
end);
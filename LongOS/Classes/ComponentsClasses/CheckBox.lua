CheckBox = Class(Component, function(this, backgroundColor, textColor, dX, dY, anchorType)
	Component.init(this, dX, dY, anchorType);

	this.GetClassName = function()
		return 'CheckBox';
	end

	this.Checked = false;

	this.BackgroundColor = backgroundColor;
	if (this.BackgroundColor == nil) then
		this.BackgroundColor = System:GetSystemColor('SystemButtonsColor');
	end
	this.TextColor = textColor;
	if (this.TextColor == nil) then
		this.TextColor = System:GetSystemColor('SystemButtonsTextColor');
	end

	this._draw = function(videoBuffer, x, y)
		this.X = x;
		this.Y = y;
		local toPrint = ' ';
		if (this.Checked) then
			toPrint = 'X';
		end
		videoBuffer:SetColorParameters(this.TextColor, this.BackgroundColor);
		videoBuffer:WriteAt(this.X, this.Y, toPrint);
	end

	local check = function(cursorX, cursorY)
		if (cursorX == this.X and cursorY == this.Y) then
			this.Checked = not this.Checked;
		end
	end

	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		check(cursorX, cursorY);
	end
end)
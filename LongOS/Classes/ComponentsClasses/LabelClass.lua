Label = Class(Component, function(this, text, backgroundColor, textColor, dX, dY, anchorType)
	Component.init(this, dX, dY, anchorType);
	this.Text = text;
	this.TextColor = textColor;
	if (this.TextColor == nil) then
		this.TextColor = System:GetSystemColor('SystemLabelsTextColor');
	end
	this.BackgroundColor = backgroundColor;
	if (this.BackgroundColor == nil) then
		this.BackgroundColor = System:GetSystemColor('WindowColor');
	end

	this._draw = function(videoBuffer, x, y)
		videoBuffer:SetTextColor(this.TextColor);
		videoBuffer:SetBackgroundColor(this.BackgroundColor);
		videoBuffer:WriteAt(x, y, this.Text);
	end
end)
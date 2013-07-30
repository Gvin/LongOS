Label = Class(Component, function(this, text, backgroundColor, textColor, dX, dY, anchorType)
	Component.init(this, dX, dY, anchorType);

	this.GetClassName = function()
		return 'Label';
	end

	this.Text = text;
	this.TextColor = textColor;
	this.BackgroundColor = backgroundColor;

	this._draw = function(videoBuffer, x, y)
		if (textColor == nil) then
			local colorConfiguration = System:GetColorConfiguration();
			this.TextColor = colorConfiguration:GetColor('SystemLabelsTextColor');
		end
		if (backgroundColor == nil) then
			local colorConfiguration = System:GetColorConfiguration();
			this.BackgroundColor = colorConfiguration:GetColor('WindowColor');
		end

		videoBuffer:SetTextColor(this.TextColor);
		videoBuffer:SetBackgroundColor(this.BackgroundColor);
		videoBuffer:WriteAt(x, y, this.Text);
	end
end)
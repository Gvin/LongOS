Label = Class(Component, function(this, text, backgroundColor, textColor, dX, dY, anchorType)
	Component.init(this, dX, dY, anchorType);

	this.GetClassName = function()
		return 'Label';
	end

	this.Text = text;
	this.TextColor = textColor;
	this.BackgroundColor = backgroundColor;

	local x;
	local y;

	this.GetText = function()
		return this.Text;
	end

	this.GetY = function()
		return y;
	end

	this.GetX = function()
		return x;
	end

	this.SetBackgroundColor = function(_, _value)
		this.BackgroundColor = _value;
	end

	this.SetTextColor = function(_, _value)
		this.TextColor = _value;
	end

	this._draw = function(videoBuffer, _x, _y)
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
		videoBuffer:WriteAt(_x, _y, this.Text);

		x = _x;
		y = _y;
	end
end)
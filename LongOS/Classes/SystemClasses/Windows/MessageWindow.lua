MessageWindow = Class(Window, function(this, _application, _title, _text, _textColor)

	local function countHeight(_text)
		return 6 + math.floor(string.len(_text) / 30);
	end

	local function countWidth(_text)
		if (string.len(_text) < 30) then
			return (4 + string.len(_text));
		end

		return 34;
	end

	local function countXPosition(_text)
		local width = countWidth(_text);
		local screenWidth = term.getSize();
		return math.floor((screenWidth - width) / 2);
	end

	local function countYPosition(_text)
		local height = countHeight(_text);
		local _, screenHeight = term.getSize();
		return math.floor((screenHeight - height) / 2);
	end

	Window.init(this, _application, 'Message Window', false, true, _title, countXPosition(_text), countYPosition(_text), countWidth(_text), countHeight(_text), nil, false, false);
	
	this.Text = _text;
	this.TextColor = _textColor;
	local colorConfiguration = System:GetColorConfiguration();

	if (this.TextColor == nil) then
		this.TextColor = colorConfiguration:GetColor('SystemLabelsTextColor');
	end

	local okButtonClick = function(sender, eventArgs)
		this:Close();
	end

	local okButton = Button(' OK ', nil, nil, math.floor(this:GetWidth() / 2 - 2), this:GetHeight() - 2, 'left-top');
	okButton:SetOnClick(EventHandler(okButtonClick));
	this:AddComponent(okButton);

	this.Draw = function(_, videoBuffer)
		videoBuffer:SetTextColor(this.TextColor);
		videoBuffer:SetBackgroundColor(colorConfiguration:GetColor('WindowColor'));
		local line = 1;
		local col = 1;
		for i = 1, string.len(this.Text) do
			videoBuffer:WriteAt(this:GetX() + 1 + col, this:GetY() + 1 + line, string.sub(this.Text, i, i));
			col = col + 1;
			if (col > 30) then
				line = line + 1;
				col = 1;
			end
		end
	end
end)
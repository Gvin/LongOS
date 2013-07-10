local function countHeight(text)
	return 6 + math.floor(string.len(text) / 30);
end

local function countWidth(text)
	if (string.len(text) < 30) then
		return (4 + string.len(text));
	end

	return 34;
end

local function okButtonClick(params)
	params[1]:Close();
end

local function countXPosition(text)
	local width = countWidth(text);
	local screenWidth = term.getSize();
	return math.floor((screenWidth - width) / 2);
end

local function countYPosition(text)
	local height = countHeight(text);
	local _, screenHeight = term.getSize();
	return math.floor((screenHeight - height) / 2);
end

MessageWindow = Class(Window, function(this, application, title, text, textColor)
	Window.init(this, application, countXPosition(text), countYPosition(text), 10, 10, false, false, nil, 'Message window', title, false);
	this:SetSize(countWidth(text), countHeight(text));
	this.Text = text;
	this.TextColor = textColor;
	this.IsModal = true;
	if (this.TextColor == nil) then
		this.TextColor = System:GetSystemColor('SystemLabelsTextColor');
	end

	local okButton = Button(' OK ', nil, nil, math.floor(this.Width / 2 - 2), this.Height - 2, 'left-top');
	okButton.OnClick = okButtonClick;
	okButton.OnClickParams = { this };
	this:AddComponent(okButton);

	this.Draw = function(_, videoBuffer)
		videoBuffer:SetTextColor(this.TextColor);
		videoBuffer:SetBackgroundColor(System:GetSystemColor('WindowColor'));
		local line = 1;
		local col = 1;
		for i = 1, string.len(this.Text) do
			videoBuffer:WriteAt(this.X + 1 + col, this.Y + 1 + line, string.sub(this.Text, i, i));
			col = col + 1;
			if (col > 30) then
				line = line + 1;
				col = 1;
			end
		end
	end
end)
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
	params[1]:Ok();
end

local function cancelButtonClick(params)
	params[1]:Cancel();
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

DialogWindow = Class(Window, function(this, application, title, text)
	Window.init(this, application, countXPosition(text), countYPosition(text), 10, 10, false, false, nil, 'Dialog window', title, false);
	this:SetSize(countWidth(text), countHeight(text));
	this.Text = text;
	this.TextColor = textColor;
	this.IsModal = true;
	this.OnOkClick = nil;
	this.OnOkClickParams = nil;
	this.OnCancelClick = nil;
	this.OnCancelClickParams = nil;
	if (this.TextColor == nil) then
		this.TextColor = System:GetSystemColor('SystemLabelsTextColor');
	end

	local okButton = Button(' OK ', nil, nil, 1, -2, 'left-bottom');
	okButton.OnClick = okButtonClick;
	okButton.OnClickParams = { this };
	this:AddComponent(okButton);

	local cancelButton = Button('Cancel', nil, nil, -7, -2, 'right-bottom');
	cancelButton.OnClick = cancelButtonClick;
	cancelButton.OnClickParams = { this };
	this:AddComponent(cancelButton);

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

	this.Ok = function(_)
		if (this.OnOkClick ~= nil) then
			this.OnOkClick(this.OnOkClickParams);
		end
		this:Close();
	end

	this.Cancel = function(_)
		if (this.OnCancelClick ~= nil) then
			this.OnCancelClick(this.OnCancelClickParams);
		end
		this:Close();
	end
end)
ColorPickerWindow = Class(Window, function(this, application, color, receiverTable)
	Window.init(this, application, 10, 3, 18, 6, false, false, nil, 'Color picker window', 'Select color', true);

	this.Color = color;
	this.IsModal = true;

	local selectColorClick = function(sender, eventArgs)
		this:SelectColor(sender:GetBackgroundColor());
	end

	local white = Button(' ', colors.white, colors.white, 1, 2, 'left-top');
	white:SetOnClick(EventHandler(selectColorClick));
	this:AddComponent(white);

	local orange = Button(' ', colors.orange, colors.white, 2, 2, 'left-top');
	orange:SetOnClick(EventHandler(selectColorClick));
	this:AddComponent(orange);

	local magenta = Button(' ', colors.magenta, colors.white, 3, 2, 'left-top');
	magenta:SetOnClick(EventHandler(selectColorClick));
	this:AddComponent(magenta);

	local lightBlue = Button(' ', colors.lightBlue, colors.white, 4, 2, 'left-top');
	lightBlue:SetOnClick(EventHandler(selectColorClick));
	this:AddComponent(lightBlue);

	local yellow = Button(' ', colors.yellow, colors.white, 5, 2, 'left-top');
	yellow:SetOnClick(EventHandler(selectColorClick));
	this:AddComponent(yellow);

	local lime = Button(' ', colors.lime, colors.white, 6, 2, 'left-top');
	lime:SetOnClick(EventHandler(selectColorClick));
	this:AddComponent(lime);

	local pink = Button(' ', colors.pink, colors.white, 7, 2, 'left-top');
	pink:SetOnClick(EventHandler(selectColorClick));
	this:AddComponent(pink);

	local gray = Button(' ', colors.gray, colors.white, 8, 2, 'left-top');
	gray:SetOnClick(EventHandler(selectColorClick));
	this:AddComponent(gray);

	local lightGray = Button(' ', colors.lightGray, colors.white, 9, 2, 'left-top');
	lightGray:SetOnClick(EventHandler(selectColorClick));
	this:AddComponent(lightGray);

	local cyan = Button(' ', colors.cyan, colors.white, 10, 2, 'left-top');
	cyan:SetOnClick(EventHandler(selectColorClick));
	this:AddComponent(cyan);

	local purple = Button(' ', colors.purple, colors.white, 11, 2, 'left-top');
	purple:SetOnClick(EventHandler(selectColorClick));
	this:AddComponent(purple);

	local blue = Button(' ', colors.blue, colors.white, 12, 2, 'left-top');
	blue:SetOnClick(EventHandler(selectColorClick));
	this:AddComponent(blue);

	local brown = Button(' ', colors.brown, colors.white, 13, 2, 'left-top');
	brown:SetOnClick(EventHandler(selectColorClick));
	this:AddComponent(brown);

	local green = Button(' ', colors.green, colors.white, 14, 2, 'left-top');
	green:SetOnClick(EventHandler(selectColorClick));
	this:AddComponent(green);

	local black = Button(' ', colors.black, colors.white, 15, 2, 'left-top');
	black:SetOnClick(EventHandler(selectColorClick));
	this:AddComponent(black);

	local red = Button(' ', colors.red, colors.white, 16, 2, 'left-top');
	red:SetOnClick(EventHandler(selectColorClick));
	this:AddComponent(red);

	local cancelButtonClick = function(sender, eventArgs)
		this:Close();
	end

	local cancelButton = Button('Cancel', nil, nil, 6, -2, 'left-bottom');
	cancelButton:SetOnClick(EventHandler(cancelButtonClick));
	this:AddComponent(cancelButton);

	this.SelectColor = function(_, color)
		this.Color = color;
		receiverTable.BackgroundColor = color;
		this:Close();
	end
end)
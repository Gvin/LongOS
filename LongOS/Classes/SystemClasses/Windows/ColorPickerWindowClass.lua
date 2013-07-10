local function selectColorClick(params)
	params[1]:SelectColor(params[2].BackgroundColor);
end

local function cancelButtonClick(params)
	params[1]:Close();
end

ColorPickerWindow = Class(Window, function(this, application, color, receiverTable)
	Window.init(this, application, 10, 3, 18, 6, false, false, nil, 'Color picker window', 'Select color', true);

	this.Color = color;
	this.IsModal = true;

	local white = Button(' ', colors.white, colors.white, 1, 2, 'left-top');
	white.OnClick = selectColorClick;
	white.OnClickParams = { this, white };
	this:AddComponent(white);
	local orange = Button(' ', colors.orange, colors.white, 2, 2, 'left-top');
	orange.OnClick = selectColorClick;
	orange.OnClickParams = { this, orange };
	this:AddComponent(orange);
	local magenta = Button(' ', colors.magenta, colors.white, 3, 2, 'left-top');
	magenta.OnClick = selectColorClick;
	magenta.OnClickParams = { this, magenta };
	this:AddComponent(magenta);
	local lightBlue = Button(' ', colors.lightBlue, colors.white, 4, 2, 'left-top');
	lightBlue.OnClick = selectColorClick;
	lightBlue.OnClickParams = { this, lightBlue };
	this:AddComponent(lightBlue);
	local yellow = Button(' ', colors.yellow, colors.white, 5, 2, 'left-top');
	yellow.OnClick = selectColorClick;
	yellow.OnClickParams = { this, yellow };
	this:AddComponent(yellow);
	local lime = Button(' ', colors.lime, colors.white, 6, 2, 'left-top');
	lime.OnClick = selectColorClick;
	lime.OnClickParams = { this, lime }
	this:AddComponent(lime);
	local pink = Button(' ', colors.pink, colors.white, 7, 2, 'left-top');
	pink.OnClick = selectColorClick;
	pink.OnClickParams = { this, pink };
	this:AddComponent(pink);
	local gray = Button(' ', colors.gray, colors.white, 8, 2, 'left-top');
	gray.OnClick = selectColorClick;
	gray.OnClickParams = { this, gray };
	this:AddComponent(gray);
	local lightGray = Button(' ', colors.lightGray, colors.white, 9, 2, 'left-top');
	lightGray.OnClick = selectColorClick;
	lightGray.OnClickParams = { this, lightGray };
	this:AddComponent(lightGray);
	local cyan = Button(' ', colors.cyan, colors.white, 10, 2, 'left-top');
	cyan.OnClick = selectColorClick;
	cyan.OnClickParams = { this, cyan };
	this:AddComponent(cyan);
	local purple = Button(' ', colors.purple, colors.white, 11, 2, 'left-top');
	purple.OnClick = selectColorClick;
	purple.OnClickParams = { this, purple };
	this:AddComponent(purple);
	local blue = Button(' ', colors.blue, colors.white, 12, 2, 'left-top');
	blue.OnClick = selectColorClick;
	blue.OnClickParams = { this, blue };
	this:AddComponent(blue);
	local brown = Button(' ', colors.brown, colors.white, 13, 2, 'left-top');
	brown.OnClick = selectColorClick;
	brown.OnClickParams = { this, brown };
	this:AddComponent(brown);
	local green = Button(' ', colors.green, colors.white, 14, 2, 'left-top');
	green.OnClick = selectColorClick;
	green.OnClickParams = { this, green };
	this:AddComponent(green);
	local black = Button(' ', colors.black, colors.white, 15, 2, 'left-top');
	black.OnClick = selectColorClick;
	black.OnClickParams = { this, black };
	this:AddComponent(black);
	local red = Button(' ', colors.red, colors.white, 16, 2, 'left-top');
	red.OnClick = selectColorClick;
	red.OnClickParams = { this, red };
	this:AddComponent(red);

	local cancelButton = Button('Cancel', nil, nil, 6, -2, 'left-bottom');
	cancelButton.OnClick = cancelButtonClick;
	cancelButton.OnClickParams = { this };
	this:AddComponent(cancelButton);

	this.SelectColor = function(_, color)
		this.Color = color;
		receiverTable.BackgroundColor = color;
		this:Close();
	end
end)
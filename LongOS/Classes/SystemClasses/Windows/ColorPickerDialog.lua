ColorPickerDialog = Class(Window, function(this, _application)

	Window.init(this, _application, 'Color picker dialog', false, true, 'Select color', 10, 3, 18, 6, nil, false, false);

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local onOk;

	local white;
	local orange;
	local magenta;
	local lightBlue;
	local yellow;
	local lime;
	local pink;
	local gray;
	local lightGray;
	local cyan;
	local purple;
	local blue;
	local brown;
	local green;
	local black;
	local red;

	local cancelButton;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this.SetOnOk(_, _value)
		onOk = _value;
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function selectColorClick(_sender, _eventArgs)
		this:Close();
		if (onOk ~= nil) then
			local color = _sender:GetBackgroundColor();
			local eventArgs = {};
			eventArgs.Color = color;
			onOk:Invoke(this, eventArgs);
		end
	end

	local function cancelButtonClick(_sender, _eventArgs)
		this:Close();
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		white = Button(' ', colors.white, colors.white, 0, 1, 'left-top');
		white:SetOnClick(EventHandler(selectColorClick));
		this:AddComponent(white);

		orange = Button(' ', colors.orange, colors.white, 1, 1, 'left-top');
		orange:SetOnClick(EventHandler(selectColorClick));
		this:AddComponent(orange);

		magenta = Button(' ', colors.magenta, colors.white, 2, 1, 'left-top');
		magenta:SetOnClick(EventHandler(selectColorClick));
		this:AddComponent(magenta);

		lightBlue = Button(' ', colors.lightBlue, colors.white, 3, 1, 'left-top');
		lightBlue:SetOnClick(EventHandler(selectColorClick));
		this:AddComponent(lightBlue);

		yellow = Button(' ', colors.yellow, colors.white, 4, 1, 'left-top');
		yellow:SetOnClick(EventHandler(selectColorClick));
		this:AddComponent(yellow);

		lime = Button(' ', colors.lime, colors.white, 5, 1, 'left-top');
		lime:SetOnClick(EventHandler(selectColorClick));
		this:AddComponent(lime);

		pink = Button(' ', colors.pink, colors.white, 6, 1, 'left-top');
		pink:SetOnClick(EventHandler(selectColorClick));
		this:AddComponent(pink);

		gray = Button(' ', colors.gray, colors.white, 7, 1, 'left-top');
		gray:SetOnClick(EventHandler(selectColorClick));
		this:AddComponent(gray);

		lightGray = Button(' ', colors.lightGray, colors.white, 8, 1, 'left-top');
		lightGray:SetOnClick(EventHandler(selectColorClick));
		this:AddComponent(lightGray);

		cyan = Button(' ', colors.cyan, colors.white, 9, 1, 'left-top');
		cyan:SetOnClick(EventHandler(selectColorClick));
		this:AddComponent(cyan);

		purple = Button(' ', colors.purple, colors.white, 10, 1, 'left-top');
		purple:SetOnClick(EventHandler(selectColorClick));
		this:AddComponent(purple);

		blue = Button(' ', colors.blue, colors.white, 11, 1, 'left-top');
		blue:SetOnClick(EventHandler(selectColorClick));
		this:AddComponent(blue);

		brown = Button(' ', colors.brown, colors.white, 12, 1, 'left-top');
		brown:SetOnClick(EventHandler(selectColorClick));
		this:AddComponent(brown);

		green = Button(' ', colors.green, colors.white, 13, 1, 'left-top');
		green:SetOnClick(EventHandler(selectColorClick));
		this:AddComponent(green);

		black = Button(' ', colors.black, colors.white, 14, 1, 'left-top');
		black:SetOnClick(EventHandler(selectColorClick));
		this:AddComponent(black);

		red = Button(' ', colors.red, colors.white, 15, 1, 'left-top');
		red:SetOnClick(EventHandler(selectColorClick));
		this:AddComponent(red);


		cancelButton = Button('Cancel', nil, nil, 5, -1, 'left-bottom');
		cancelButton:SetOnClick(EventHandler(cancelButtonClick));
		this:AddComponent(cancelButton);
	end

	local function constructor()
		initializeComponents();
	end

	constructor();
end)
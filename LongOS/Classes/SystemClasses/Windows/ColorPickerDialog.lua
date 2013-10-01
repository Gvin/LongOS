local Window = Classes.Application.Window;
local Button = Classes.Components.Button;
local EventHandler = Classes.System.EventHandler;

Classes.System.Windows.ColorPickerDialog = Class(Window, function(this, _application)

	Window.init(this, _application, 'Color picker dialog', false);
	this:SetTitle('Select color');
	this:SetX(10);
	this:SetY(3);
	this:SetWidth(18);
	this:SetHeight(6);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
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

	function this.AddOnOkEventHandler(_, _value)
		onOk:AddHandler(_value);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function selectColorClick(_sender, _eventArgs)
		this:Close();
		local color = _sender:GetBackgroundColor();
		local eventArgs = {};
		eventArgs.Color = color;
		onOk:Invoke(this, eventArgs);
	end

	local function cancelButtonClick(_sender, _eventArgs)
		this:Close();
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		white = Button(' ', colors.white, colors.white, 0, 1, 'left-top');
		white:AddOnClickEventHandler(selectColorClick);
		this:AddComponent(white);

		orange = Button(' ', colors.orange, colors.white, 1, 1, 'left-top');
		orange:AddOnClickEventHandler(selectColorClick);
		this:AddComponent(orange);

		magenta = Button(' ', colors.magenta, colors.white, 2, 1, 'left-top');
		magenta:AddOnClickEventHandler(selectColorClick);
		this:AddComponent(magenta);

		lightBlue = Button(' ', colors.lightBlue, colors.white, 3, 1, 'left-top');
		lightBlue:AddOnClickEventHandler(selectColorClick);
		this:AddComponent(lightBlue);

		yellow = Button(' ', colors.yellow, colors.white, 4, 1, 'left-top');
		yellow:AddOnClickEventHandler(selectColorClick);
		this:AddComponent(yellow);

		lime = Button(' ', colors.lime, colors.white, 5, 1, 'left-top');
		lime:AddOnClickEventHandler(selectColorClick);
		this:AddComponent(lime);

		pink = Button(' ', colors.pink, colors.white, 6, 1, 'left-top');
		pink:AddOnClickEventHandler(selectColorClick);
		this:AddComponent(pink);

		gray = Button(' ', colors.gray, colors.white, 7, 1, 'left-top');
		gray:AddOnClickEventHandler(selectColorClick);
		this:AddComponent(gray);

		lightGray = Button(' ', colors.lightGray, colors.white, 8, 1, 'left-top');
		lightGray:AddOnClickEventHandler(selectColorClick);
		this:AddComponent(lightGray);

		cyan = Button(' ', colors.cyan, colors.white, 9, 1, 'left-top');
		cyan:AddOnClickEventHandler(selectColorClick);
		this:AddComponent(cyan);

		purple = Button(' ', colors.purple, colors.white, 10, 1, 'left-top');
		purple:AddOnClickEventHandler(selectColorClick);
		this:AddComponent(purple);

		blue = Button(' ', colors.blue, colors.white, 11, 1, 'left-top');
		blue:AddOnClickEventHandler(selectColorClick);
		this:AddComponent(blue);

		brown = Button(' ', colors.brown, colors.white, 12, 1, 'left-top');
		brown:AddOnClickEventHandler(selectColorClick);
		this:AddComponent(brown);

		green = Button(' ', colors.green, colors.white, 13, 1, 'left-top');
		green:AddOnClickEventHandler(selectColorClick);
		this:AddComponent(green);

		black = Button(' ', colors.black, colors.white, 14, 1, 'left-top');
		black:AddOnClickEventHandler(selectColorClick);
		this:AddComponent(black);

		red = Button(' ', colors.red, colors.white, 15, 1, 'left-top');
		red:AddOnClickEventHandler(selectColorClick);
		this:AddComponent(red);


		cancelButton = Button('Cancel', nil, nil, 5, 0, 'left-bottom');
		cancelButton:AddOnClickEventHandler(cancelButtonClick);
		this:AddComponent(cancelButton);
	end

	local function constructor()
		onOk = EventHandler();

		initializeComponents();
	end

	constructor();
end)
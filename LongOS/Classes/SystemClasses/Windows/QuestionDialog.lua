local Window = Classes.Application.Window;
local Button = Classes.Components.Button;
local EventHandler = Classes.System.EventHandler;


Classes.System.Windows.QuestionDialog = Class(Window, function(this, _application, _title, _text)
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

	local width = countWidth(_text);
	local height = countHeight(_text);

	Window.init(this, _application, 'Question dialog', false);
	this:SetTitle(_title);
	this:SetX(countXPosition(_text));
	this:SetY(countYPosition(_text));
	this:SetWidth(width);
	this:SetHeight(height);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local onYes;
	local onNo;
	local text;

	local yesButton;
	local noButton;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this.AddOnYesEventHandler(_, _value)
		onYes:AddHandler(_value);
	end

	function this.AddOnNoEventHandler(_, _value)
		onNo:AddHandler(_value);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this.Draw(_, _videoBuffer)
		local colorConfiguration = System:GetColorConfiguration();

		_videoBuffer:SetTextColor(colorConfiguration:GetColor('SystemLabelsTextColor'));
		_videoBuffer:SetBackgroundColor(colorConfiguration:GetColor('WindowColor'));
		local line = 1;
		local col = 1;
		for i = 1, string.len(text) do
			_videoBuffer:WriteAt(1 + col, 1 + line, string.sub(text, i, i));
			col = col + 1;
			if (col > 30) then
				line = line + 1;
				col = 1;
			end
		end
	end

	local function yesButtonClick(_sender, _eventArgs)
		this:Close();

		onYes:Invoke(this, { });
	end

	local function noButtonClick(_sender, _eventArgs)
		this:Close();

		onNo:Invoke(this, { });
	end

	function this.ProcessKeyEvent(_, _key)
		if (keys.getName(_key) == 'enter') then
			yesButtonClick(nil, nil);
		end
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents(_text)
		yesButton = Button(' Yes ', nil, nil, 0, 0, 'left-bottom');
		yesButton:AddOnClickEventHandler(yesButtonClick);
		this:AddComponent(yesButton);

		noButton = Button(' No ', nil, nil, 0, 0, 'right-bottom');
		noButton:AddOnClickEventHandler(noButtonClick);
		this:AddComponent(noButton);
	end

	local function constructor(_application, _title, _text)
		if (type(_text) ~= 'string') then
			error('QuestionDialog.Constructor [text]: String expected, got '..type(_text)..'.');
		end

		text = _text;

		onYes = EventHandler();
		onNo = EventHandler();

		initializeComponents(_text);
	end

	constructor(_application, _title, _text);
end)
QuestionDialog = Class(Window, function(this, _application, _title, _text)
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

	Window.init(this, _application, 'Question dialog', false, true, _title, countXPosition(_text), countYPosition(_text), countWidth(_text), countHeight(_text), nil, false, false);

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

	function this.SetOnYes(_, _value)
		onYes = _value;
	end

	function this.SetOnNo(_, _value)
		onNo = _value;
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

		if (onYes ~= nil) then
			onYes:Invoke(this, { });
		end
	end

	local function noButtonClick(_sender, _eventArgs)
		this:Close();

		if (onNo ~= nil) then
			onNo:Invoke(this, { });
		end
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
		yesButton = Button(' Yes ', nil, nil, 0, -1, 'left-bottom');
		yesButton:SetOnClick(EventHandler(yesButtonClick));
		this:AddComponent(yesButton);

		noButton = Button(' No ', nil, nil, -4, -1, 'right-bottom');
		noButton:SetOnClick(EventHandler(noButtonClick));
		this:AddComponent(noButton);
	end

	local function constructor(_application, _title, _text)
		if (type(_text) ~= 'string') then
			error('QuestionDialog.Constructor [text]: String expected, got '..type(_text)..'.');
		end

		text = _text;

		onYes = nil;
		onNo = nil;

		initializeComponents(_text);
	end

	constructor(_application, _title, _text);
end)
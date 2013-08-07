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

	local width = countWidth(_text);
	local height = countHeight(_text);

	Window.init(this, _application, 'Message Window', false);
	this:SetIsModal(true);
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

	local text;
	local textColor;

	local okButton;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this.Draw(_, _videoBuffer)
		local colorConfiguration = System:GetColorConfiguration();
		
		_videoBuffer:SetTextColor(textColor);
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

	local function okButtonClick(_sender, _eventArgs)
		this:Close();
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		okButton = Button(' OK ', nil, nil, math.floor(this:GetWidth() / 2 - 3), -1, 'left-bottom');
		okButton:SetOnClick(EventHandler(okButtonClick));
		this:AddComponent(okButton);
	end

	local function constructor(_application, _title, _text, _textColor)
		if (type(_text) ~= 'string') then
			error('MessageWindow.Constructor [text]: String expected, got '..type(_text)..'.');
		end
		if (_textColor ~= nil and type(_textColor) ~= 'number') then
			error('MessageWindow.Constructor [textColor]: Number or nil expected, got '..type(_textColor)..'.');
		end

		text = _text;
		textColor = _textColor;

		local colorConfiguration = System:GetColorConfiguration();
		if (textColor == nil) then
			textColor = colorConfiguration:GetColor('SystemLabelsTextColor');
		end

		initializeComponents();
	end

	constructor(_application, _title, _text, _textColor);
end)
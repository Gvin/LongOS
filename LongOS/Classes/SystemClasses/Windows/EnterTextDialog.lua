local Window = Classes.Application.Window;
local Button = Classes.Components.Button;
local Edit = Classes.Components.Edit;
local Label = Classes.Components.Label;
local EventHandler = Classes.System.EventHandler;

EnterTextDialog = Class(Window, function(this, _application, _title, _text, _initialText)

	Window.init(this, _application, 'Enter text dialog', false);
	this:SetIsModal(true);
	this:SetTitle(_title);
	this:SetX(10);
	this:SetY(7);
	this:SetWidth(30);
	this:SetHeight(7);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local onOk;
	local onCancel;

	local okButton;
	local cancelButton;
	local textEdit;
	local textLabel;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this.SetOnOk(_, _value)
		onOk:AddHandler(_value);
	end

	function this.SetOnCancel(_, _value)
		onCancel:AddHandler(_value);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function okButtonClick(_sender, _eventArgs)
		local text = textEdit:GetText();

		this:Close();

		local eventArgs = {};
		eventArgs.Text = text;
		onOk:Invoke(this, eventArgs);
	end

	local function cancelButtonClick(_sender, _eventArgs)
		this:Close();

		onCancel:Invoke(this, { });
	end

	function this.ProcessKeyEvent(_, _key)
		if (keys.getName(_key) == 'enter') then
			okButtonClick(nil, nil);
		end
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents(_text, _initialText)
		okButton = Button(' OK ', nil, nil, 0, 0, 'left-bottom');
		okButton:SetOnClick(okButtonClick);
		this:AddComponent(okButton);

		local cancelButton = Button('Cancel', nil, nil, 0, 0, 'right-bottom');
		cancelButton:SetOnClick(cancelButtonClick);
		this:AddComponent(cancelButton);

		textLabel = Label(_text, nil, nil, 1, 1, 'left-top');
		this:AddComponent(textLabel);

		textEdit = Edit(26, colors.white, colors.black, 1, 2, 'left-top');
		if (_initialText ~= nil) then
			textEdit:SetText(_initialText);
		end
		textEdit:SetFocus(true);
		this:AddComponent(textEdit);
	end

	local function constructor(_application, _title, _text, _initialText)
		onOk = EventHandler();
		onCancel = EventHandler();

		initializeComponents(_text, _initialText);
	end

	constructor(_application, _title, _text, _initialText);
end)
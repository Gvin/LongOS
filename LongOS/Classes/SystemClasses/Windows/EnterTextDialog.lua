EnterTextDialog = Class(Window, function(this, _application, _title, _text, _initialText)

	Window.init(this, _application, 'Enter text dialog', false, true, _title, 10, 7, 30, 7, 30, 7, nil, false, true);

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
		onOk = _value;
	end

	function this.SetOnCancel(_, _value)
		onCancel = _value;
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function okButtonClick(_sender, _eventArgs)
		local text = textEdit.Text;

		this:Close();

		if (onOk ~= nil) then
			local eventArgs = {};
			eventArgs.Text = text;
			onOk:Invoke(this, eventArgs);
		end
	end

	local function cancelButtonClick(_sender, _eventArgs)
		this:Close();

		if (onCancel ~= nil) then
			onCancel:Invoke(this, { });
		end
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
		okButton = Button(' OK ', nil, nil, 0, -1, 'left-bottom');
		okButton:SetOnClick(EventHandler(okButtonClick));
		this:AddComponent(okButton);

		local cancelButton = Button('Cancel', nil, nil, -6, -1, 'right-bottom');
		cancelButton:SetOnClick(EventHandler(cancelButtonClick));
		this:AddComponent(cancelButton);

		textLabel = Label(_text, nil, nil, 1, 1, 'left-top');
		this:AddComponent(textLabel);

		textEdit = Edit(26, colors.white, colors.black, 1, 2, 'left-top');
		if (_initialText ~= nil) then
			textEdit.Text = _initialText;
		end
		textEdit:SetFocus(true);
		this:AddComponent(textEdit);
	end

	local function constructor(_application, _title, _text, _initialText)
		onOk = nil;
		onCancel = nil;

		initializeComponents(_text, _initialText);
	end

	constructor(_application, _title, _text, _initialText);
end)
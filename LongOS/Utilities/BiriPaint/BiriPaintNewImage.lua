BiriPaintNewImage = Class(Window, function(this, _application, _title,_initialWidth, _initialHeight)

	Window.init(this, _application, 'Paint new dialog', false, true, _title, 10, 7, 30, 9, nil, false, true);

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local onOk;
	local onCancel;

	local okButton;
	local cancelButton;
	local widthEdit;
	local widthLabel;
	local heightEdit;
	local heightLabel;

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
		local width = tonumber(widthEdit.Text);
		local height = tonumber(heightEdit.Text);
		if (width and height ~= nil ) then
			this:Close();
			if (onOk ~= nil) then
				local eventArgs = {};
				eventArgs.Width = width;
				eventArgs.Height = height;
				onOk:Invoke(this, eventArgs);
			end					
		else
			local errorWindow = MessageWindow(this:GetApplication(), 'Not a number', 'Width and height must be a number');			
			errorWindow:Show();	
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

	local function initializeComponents(_initialWidth, _initialHeight)
		okButton = Button(' OK ', nil, nil, 0, -1, 'left-bottom');
		okButton:SetOnClick(EventHandler(okButtonClick));
		this:AddComponent(okButton);

		local cancelButton = Button('Cancel', nil, nil, -6, -1, 'right-bottom');
		cancelButton:SetOnClick(EventHandler(cancelButtonClick));
		this:AddComponent(cancelButton);

		widthLabel = Label('Width', nil, nil, 1, 1, 'left-top');
		this:AddComponent(widthLabel);

		widthEdit = Edit(26, colors.white, colors.black, 1, 2, 'left-top');
		if (_initialWidth ~= nil) then
			widthEdit.Text = _initialWidth;
		end
		widthEdit:SetFocus(true);
		this:AddComponent(widthEdit);

		heightLabel = Label('Height', nil, nil, 1, 3, 'left-top');
		this:AddComponent(heightLabel);

		heightEdit = Edit(26, colors.white, colors.black, 1, 4, 'left-top');
		if (_initialHeight ~= nil) then
			heightEdit.Text = _initialHeight;
		end

		this:AddComponent(heightEdit);
	end

	local function constructor(_application, _title, _initialWidth, _initialHeight)
		onOk = nil;
		onCancel = nil;

		initializeComponents(_initialWidth, _initialHeight);
	end

	constructor(_application, _title, _initialWidth, _initialHeight);
end)
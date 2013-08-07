ColorConfigurationWindow = Class(Window, function(this, _application)
	Window.init(this, _application, 'Color configuration window', false, false, 'Color configuration', 7, 3, 36, 16, 36, 16, nil, false, true);

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local colorConfiguration;

	local selectedButton;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function updateConfiguration()
		colorConfiguration:SetColor('WindowColor', windowColorButton:GetBackgroundColor());
		colorConfiguration:SetColor('WindowBorderColor', windowBorderColorButton:GetBackgroundColor());
		colorConfiguration:SetColor('TopLineActiveColor', topLineActiveColorButton:GetBackgroundColor());
		colorConfiguration:SetColor('TopLineInactiveColor', topLineInactiveColorButton:GetBackgroundColor());
		colorConfiguration:SetColor('TopLineTextColor', topLineTextColorButton:GetBackgroundColor());
		colorConfiguration:SetColor('ControlPanelColor', controlPanelColorButton:GetBackgroundColor());
		colorConfiguration:SetColor('TimeTextColor', timeTextColorButton:GetBackgroundColor());
		colorConfiguration:SetColor('ControlPanelButtonsColor', controlPanelButtonsColorButton:GetBackgroundColor());
		colorConfiguration:SetColor('ControlPanelPowerButtonColor', controlPanelPowerButtonColorButton:GetBackgroundColor());
		colorConfiguration:SetColor('SystemButtonsColor', systemButtonsColorButton:GetBackgroundColor());
		colorConfiguration:SetColor('SystemButtonsTextColor', systemButtonsTextColorButton:GetBackgroundColor());
		colorConfiguration:SetColor('SystemLabelsTextColor', systemLabelsTextColorButton:GetBackgroundColor());
	end

	local function colorPickerOnOk(_sender, _eventArgs)
		selectedButton:SetBackgroundColor(_eventArgs.Color);
		updateConfiguration();
	end

	local function selectColorButtonClick(_sender, _eventArgs)
		selectedButton = _sender;
		local picker = ColorPickerDialog(this:GetApplication());
		picker:SetOnOk(EventHandler(colorPickerOnOk));
		picker:Show();
	end

	local function saveChangesButtonClick(params)
		colorConfiguration:WriteConfiguration();
		this:Close();
	end

	local function cancelButtonClick(params)
		colorConfiguration:ReadConfiguration();
		this:Close();
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		windowColorLabel = Label('Window color:', nil, nil, 0, 0, 'left-top');
		this:AddComponent(windowColorLabel);

		windowColorButton = Button(' ', colorConfiguration:GetColor('WindowColor'), nil, -1, 0, 'right-top');
		windowColorButton:SetOnClick(EventHandler(selectColorButtonClick));
		this:AddComponent(windowColorButton);

		windowBorderColorLabel = Label('Window border color:', nil, nil, 0, 1, 'left-top');
		this:AddComponent(windowBorderColorLabel);

		windowBorderColorButton = Button(' ', colorConfiguration:GetColor('WindowBorderColor'), nil, -1, 1, 'right-top');
		windowBorderColorButton:SetOnClick(EventHandler(selectColorButtonClick));
		this:AddComponent(windowBorderColorButton);

		topLineActiveColorLabel = Label('Top line active color:', nil, nil, 0, 2, 'left-top');
		this:AddComponent(topLineActiveColorLabel);

		topLineActiveColorButton = Button(' ', colorConfiguration:GetColor('TopLineActiveColor'), nil, -1, 2, 'right-top');
		topLineActiveColorButton:SetOnClick(EventHandler(selectColorButtonClick));
		this:AddComponent(topLineActiveColorButton);

		topLineInactiveColorLabel = Label('Top line inactive color:', nil, nil, 0, 3, 'left-top');
		this:AddComponent(topLineInactiveColorLabel);

		topLineInactiveColorButton = Button(' ', colorConfiguration:GetColor('TopLineInactiveColor'), nil, -1, 3, 'right-top');
		topLineInactiveColorButton:SetOnClick(EventHandler(selectColorButtonClick));
		this:AddComponent(topLineInactiveColorButton);

		topLineTextColorLabel = Label('Top line text color:', nil, nil, 0, 4, 'left-top');
		this:AddComponent(topLineTextColorLabel);

		topLineTextColorButton = Button(' ', colorConfiguration:GetColor('TopLineTextColor'), nil, -1, 4, 'right-top');
		topLineTextColorButton:SetOnClick(EventHandler(selectColorButtonClick));
		this:AddComponent(topLineTextColorButton);

		controlPanelColorLabel = Label('Control panel color:', nil, nil, 0, 5, 'left-top');
		this:AddComponent(controlPanelColorLabel);

		controlPanelColorButton = Button(' ', colorConfiguration:GetColor('ControlPanelColor'), nil, -1, 5, 'right-top');
		controlPanelColorButton:SetOnClick(EventHandler(selectColorButtonClick));
		this:AddComponent(controlPanelColorButton);

		timeTextColorLabel = Label('Time text color:', nil, nil, 0, 6, 'left-top');
		this:AddComponent(timeTextColorLabel);

		timeTextColorButton = Button(' ', colorConfiguration:GetColor('TimeTextColor'), nil, -1, 6, 'right-top');
		timeTextColorButton:SetOnClick(EventHandler(selectColorButtonClick));
		this:AddComponent(timeTextColorButton);

		controlPanelButtonsColorLabel = Label('Control panel buttons color:', nil, nil, 0, 7, 'left-top');
		this:AddComponent(controlPanelButtonsColorLabel);

		controlPanelButtonsColorButton = Button(' ', colorConfiguration:GetColor('ControlPanelButtonsColor'), nil, -1, 7, 'right-top');
		controlPanelButtonsColorButton:SetOnClick(EventHandler(selectColorButtonClick));
		this:AddComponent(controlPanelButtonsColorButton);

		controlPanelPowerButtonColorLabel = Label('Control panel power button color:', nil, nil, 0, 8, 'left-top');
		this:AddComponent(controlPanelPowerButtonColorLabel);

		controlPanelPowerButtonColorButton = Button(' ', colorConfiguration:GetColor('ControlPanelPowerButtonColor'), nil, -1, 8, 'right-top');
		controlPanelPowerButtonColorButton:SetOnClick(EventHandler(selectColorButtonClick));
		this:AddComponent(controlPanelPowerButtonColorButton);

		systemButtonsColorLabel = Label('System buttons color:', nil, nil, 0, 9, 'left-top');
		this:AddComponent(systemButtonsColorLabel);

		systemButtonsColorButton = Button(' ', colorConfiguration:GetColor('SystemButtonsColor'), nil, -1, 9, 'right-top');
		systemButtonsColorButton:SetOnClick(EventHandler(selectColorButtonClick));
		this:AddComponent(systemButtonsColorButton);

		systemButtonsTextColorLabel = Label('System buttons text color:', nil, nil, 0, 10, 'left-top');
		this:AddComponent(systemButtonsTextColorLabel);

		systemButtonsTextColorButton = Button(' ', colorConfiguration:GetColor('SystemButtonsTextColor'), nil, -1, 10, 'right-top');
		systemButtonsTextColorButton:SetOnClick(EventHandler(selectColorButtonClick));
		this:AddComponent(systemButtonsTextColorButton);

		systemLabelsTextColorLabel = Label('System labels text color:', nil, nil, 0, 11, 'left-top');
		this:AddComponent(systemLabelsTextColorLabel);

		systemLabelsTextColorButton = Button(' ', colorConfiguration:GetColor('SystemLabelsTextColor'), nil, -1, 11, 'right-top');
		systemLabelsTextColorButton:SetOnClick(EventHandler(selectColorButtonClick));
		this:AddComponent(systemLabelsTextColorButton);


		saveChangesButton = Button('Save changes', nil, nil, 0, -1, 'left-bottom');
		saveChangesButton:SetOnClick(EventHandler(saveChangesButtonClick));
		this:AddComponent(saveChangesButton);

		cancelButton = Button('Cancel', nil, nil, -6, -1, 'right-bottom');
		cancelButton:SetOnClick(EventHandler(cancelButtonClick));
		this:AddComponent(cancelButton);
	end

	local function constructor()
		colorConfiguration = System:GetColorConfiguration();

		initializeComponents();
	end

	constructor();
end)
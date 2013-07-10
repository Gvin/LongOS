local function selectColorClick(params)
	local picker = ColorPickerWindow(params[1], params[2].BackgroundColor, params[2]);
	picker:Show();
end

local function saveChangesButtonClick(params)
	params[1]:SaveChanges();
end

local function cancelButtonClick(params)
	params[1]:Cancel();
end

ColorConfigurationWindow = Class(Window, function(this, application)
	Window.init(this, application, 7, 3, 36, 16, false, true, nil, 'Color configuration window', 'Color configuration', true);

	local windowColorLabel = Label('Window color:', nil, nil, 1, 1, 'left-top');
	this:AddComponent(windowColorLabel);

	local windowColorButton = Button(' ', System:GetSystemColor('WindowColor'), nil, -2, 1, 'right-top');
	windowColorButton.OnClick = selectColorClick;
	windowColorButton.OnClickParams = { application, windowColorButton };
	this:AddComponent(windowColorButton);

	local windowBorderColorLabel = Label('Window border color:', nil, nil, 1, 2, 'left-top');
	this:AddComponent(windowBorderColorLabel);

	local windowBorderColorButton = Button(' ', System:GetSystemColor('WindowBorderColor'), nil, -2, 2, 'right-top');
	windowBorderColorButton.OnClick = selectColorClick;
	windowBorderColorButton.OnClickParams = { application, windowBorderColorButton };
	this:AddComponent(windowBorderColorButton);

	local topLineActiveColorLabel = Label('Top line active color:', nil, nil, 1, 3, 'left-top');
	this:AddComponent(topLineActiveColorLabel);

	local topLineActiveColorButton = Button(' ', System:GetSystemColor('TopLineActiveColor'), nil, -2, 3, 'right-top');
	topLineActiveColorButton.OnClick = selectColorClick;
	topLineActiveColorButton.OnClickParams = { application, topLineActiveColorButton };
	this:AddComponent(topLineActiveColorButton);

	local topLineInactiveColorLabel = Label('Top line inactive color:', nil, nil, 1, 4, 'left-top');
	this:AddComponent(topLineInactiveColorLabel);

	local topLineInactiveColorButton = Button(' ', System:GetSystemColor('TopLineInactiveColor'), nil, -2, 4, 'right-top');
	topLineInactiveColorButton.OnClick = selectColorClick;
	topLineInactiveColorButton.OnClickParams = { application, topLineInactiveColorButton };
	this:AddComponent(topLineInactiveColorButton);

	local topLineTextColorLabel = Label('Top line text color:', nil, nil, 1, 5, 'left-top');
	this:AddComponent(topLineTextColorLabel);

	local topLineTextColorButton = Button(' ', System:GetSystemColor('TopLineTextColor'), nil, -2, 5, 'right-top');
	topLineTextColorButton.OnClick = selectColorClick;
	topLineTextColorButton.OnClickParams = { application, topLineTextColorButton };
	this:AddComponent(topLineTextColorButton);

	local controlPanelColorLabel = Label('Control panel color:', nil, nil, 1, 6, 'left-top');
	this:AddComponent(controlPanelColorLabel);

	local controlPanelColorButton = Button(' ', System:GetSystemColor('ControlPanelColor'), nil, -2, 6, 'right-top');
	controlPanelColorButton.OnClick = selectColorClick;
	controlPanelColorButton.OnClickParams = { application, controlPanelColorButton };
	this:AddComponent(controlPanelColorButton);

	local timeTextColorLabel = Label('Time text color:', nil, nil, 1, 7, 'left-top');
	this:AddComponent(timeTextColorLabel);

	local timeTextColorButton = Button(' ', System:GetSystemColor('TimeTextColor'), nil, -2, 7, 'right-top');
	timeTextColorButton.OnClick = selectColorClick;
	timeTextColorButton.OnClickParams = { application, timeTextColorButton };
	this:AddComponent(timeTextColorButton);

	local controlPanelButtonsColorLabel = Label('Control panel buttons color:', nil, nil, 1, 8, 'left-top');
	this:AddComponent(controlPanelButtonsColorLabel);

	local controlPanelButtonsColorButton = Button(' ', System:GetSystemColor('ControlPanelButtonsColor'), nil, -2, 8, 'right-top');
	controlPanelButtonsColorButton.OnClick = selectColorClick;
	controlPanelButtonsColorButton.OnClickParams = { application, controlPanelButtonsColorButton };
	this:AddComponent(controlPanelButtonsColorButton);

	local controlPanelPowerButtonColorLabel = Label('Control panel power button color:', nil, nil, 1, 9, 'left-top');
	this:AddComponent(controlPanelPowerButtonColorLabel);

	local controlPanelPowerButtonColorButton = Button(' ', System:GetSystemColor('ControlPanelPowerButtonColor'), nil, -2, 9, 'right-top');
	controlPanelPowerButtonColorButton.OnClick = selectColorClick;
	controlPanelPowerButtonColorButton.OnClickParams = { application, controlPanelPowerButtonColorButton };
	this:AddComponent(controlPanelPowerButtonColorButton);

	local systemButtonsColorLabel = Label('System buttons color:', nil, nil, 1, 10, 'left-top');
	this:AddComponent(systemButtonsColorLabel);

	local systemButtonsColorButton = Button(' ', System:GetSystemColor('SystemButtonsColor'), nil, -2, 10, 'right-top');
	systemButtonsColorButton.OnClick = selectColorClick;
	systemButtonsColorButton.OnClickParams = { application, systemButtonsColorButton };
	this:AddComponent(systemButtonsColorButton);

	local systemButtonsTextColorLabel = Label('System buttons text color:', nil, nil, 1, 11, 'left-top');
	this:AddComponent(systemButtonsTextColorLabel);

	local systemButtonsTextColorButton = Button(' ', System:GetSystemColor('SystemButtonsTextColor'), nil, -2, 11, 'right-top');
	systemButtonsTextColorButton.OnClick = selectColorClick;
	systemButtonsTextColorButton.OnClickParams = { application, systemButtonsTextColorButton };
	this:AddComponent(systemButtonsTextColorButton);

	local systemLabelsTextColorLabel = Label('System labels text color:', nil, nil, 1, 12, 'left-top');
	this:AddComponent(systemLabelsTextColorLabel);

	local systemLabelsTextColorButton = Button(' ', System:GetSystemColor('SystemLabelsTextColor'), nil, -2, 12, 'right-top');
	systemLabelsTextColorButton.OnClick = selectColorClick;
	systemLabelsTextColorButton.OnClickParams = { application, systemLabelsTextColorButton };
	this:AddComponent(systemLabelsTextColorButton);


	local saveChangesButton = Button('Save changes', nil, nil, 1, -2, 'left-bottom');
	saveChangesButton.OnClick = saveChangesButtonClick;
	saveChangesButton.OnClickParams = { this };
	this:AddComponent(saveChangesButton);

	local cancelButton = Button('Cancel', nil, nil, -7, -2, 'right-bottom');
	cancelButton.OnClick = cancelButtonClick;
	cancelButton.OnClickParams = { this };
	this:AddComponent(cancelButton);


	this.Update = function(_)
		System:SetSystemColor('WindowColor', windowColorButton.BackgroundColor);
		System:SetSystemColor('WindowBorderColor', windowBorderColorButton.BackgroundColor);
		System:SetSystemColor('TopLineActiveColor', topLineActiveColorButton.BackgroundColor);
		System:SetSystemColor('TopLineInactiveColor', topLineInactiveColorButton.BackgroundColor);
		System:SetSystemColor('TopLineTextColor', topLineTextColorButton.BackgroundColor);
		System:SetSystemColor('ControlPanelColor', controlPanelColorButton.BackgroundColor);
		System:SetSystemColor('TimeTextColor', timeTextColorButton.BackgroundColor);
		System:SetSystemColor('ControlPanelButtonsColor', controlPanelButtonsColorButton.BackgroundColor);
		System:SetSystemColor('ControlPanelPowerButtonColor', controlPanelPowerButtonColorButton.BackgroundColor);
		System:SetSystemColor('SystemButtonsColor', systemButtonsColorButton.BackgroundColor);
		System:SetSystemColor('SystemButtonsTextColor', systemButtonsTextColorButton.BackgroundColor);
		System:SetSystemColor('SystemLabelsTextColor', systemLabelsTextColorButton.BackgroundColor);
	end

	this.SaveChanges = function(_)
		System:SaveColorSchemaConfiguration();
		this:Close();
	end

	this.Cancel = function(_)
		System:LoadColorSchemaConfiguration();
		this:Close();
	end
end)
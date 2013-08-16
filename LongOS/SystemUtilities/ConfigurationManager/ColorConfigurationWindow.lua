local Window = Classes.Application.Window;
local Label = Classes.Components.Label;
local Button = Classes.Components.Button;
local ColorPickerDialog = Classes.System.Windows.ColorPickerDialog;

ColorConfigurationWindow = Class(Window, function(this, _application)
	Window.init(this, _application, 'Color configuration window', false);
	this:SetIsModal(true);
	this:SetTitle('Color configuration');
	this:SetX(7);
	this:SetY(3);
	this:SetWidth(36);
	this:SetHeight(17);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);

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
		colorConfiguration:SetColor('ControlPanelButtonsColor', controlPanelButtonsColorButton:GetBackgroundColor());
		colorConfiguration:SetColor('ControlPanelPowerButtonColor', controlPanelPowerButtonColorButton:GetBackgroundColor());
		colorConfiguration:SetColor('TimeTextColor', timeTextColorButton:GetBackgroundColor());
		colorConfiguration:SetColor('SystemButtonsColor', systemButtonsColorButton:GetBackgroundColor());
		colorConfiguration:SetColor('SystemButtonsTextColor', systemButtonsTextColorButton:GetBackgroundColor());
		colorConfiguration:SetColor('SystemLabelsTextColor', systemLabelsTextColorButton:GetBackgroundColor());	
		colorConfiguration:SetColor('SystemEditsBackgroundColor', systemEditsBackgroundColorButton:GetBackgroundColor());
	
	end

	local function colorPickerOnOk(_sender, _eventArgs)
		selectedButton:SetBackgroundColor(_eventArgs.Color);
		updateConfiguration();
	end

	local function selectColorButtonClick(_sender, _eventArgs)
		selectedButton = _sender;
		local picker = ColorPickerDialog(this:GetApplication());
		picker:SetOnOk(colorPickerOnOk);
		picker:Show();
	end

	local function saveChangesButtonClick(_sender, _eventArgs)
		colorConfiguration:WriteConfiguration();
		this:Close();
	end

	local function cancelButtonClick(_sender, _eventArgs)
		colorConfiguration:ReadConfiguration();
		this:Close();
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		windowColorLabel = Label('Window color:', nil, nil, 0, 0, 'left-top');
		this:AddComponent(windowColorLabel);

		windowColorButton = Button(' ', colorConfiguration:GetColor('WindowColor'), nil, 0, 0, 'right-top');
		windowColorButton:SetOnClick(selectColorButtonClick);
		this:AddComponent(windowColorButton);

		windowBorderColorLabel = Label('Window border color:', nil, nil, 0, 1, 'left-top');
		this:AddComponent(windowBorderColorLabel);

		windowBorderColorButton = Button(' ', colorConfiguration:GetColor('WindowBorderColor'), nil, 0, 1, 'right-top');
		windowBorderColorButton:SetOnClick(selectColorButtonClick);
		this:AddComponent(windowBorderColorButton);

		topLineActiveColorLabel = Label('Top line active color:', nil, nil, 0, 2, 'left-top');
		this:AddComponent(topLineActiveColorLabel);

		topLineActiveColorButton = Button(' ', colorConfiguration:GetColor('TopLineActiveColor'), nil, 0, 2, 'right-top');
		topLineActiveColorButton:SetOnClick(selectColorButtonClick);
		this:AddComponent(topLineActiveColorButton);

		topLineInactiveColorLabel = Label('Top line inactive color:', nil, nil, 0, 3, 'left-top');
		this:AddComponent(topLineInactiveColorLabel);

		topLineInactiveColorButton = Button(' ', colorConfiguration:GetColor('TopLineInactiveColor'), nil, 0, 3, 'right-top');
		topLineInactiveColorButton:SetOnClick(selectColorButtonClick);
		this:AddComponent(topLineInactiveColorButton);

		topLineTextColorLabel = Label('Top line text color:', nil, nil, 0, 4, 'left-top');
		this:AddComponent(topLineTextColorLabel);

		topLineTextColorButton = Button(' ', colorConfiguration:GetColor('TopLineTextColor'), nil, 0, 4, 'right-top');
		topLineTextColorButton:SetOnClick(selectColorButtonClick);
		this:AddComponent(topLineTextColorButton);

		controlPanelColorLabel = Label('Control panel color:', nil, nil, 0, 5, 'left-top');
		this:AddComponent(controlPanelColorLabel);

		controlPanelColorButton = Button(' ', colorConfiguration:GetColor('ControlPanelColor'), nil, 0, 5, 'right-top');
		controlPanelColorButton:SetOnClick(selectColorButtonClick);
		this:AddComponent(controlPanelColorButton);		

		controlPanelButtonsColorLabel = Label('Control panel buttons color:', nil, nil, 0, 6, 'left-top');
		this:AddComponent(controlPanelButtonsColorLabel);

		controlPanelButtonsColorButton = Button(' ', colorConfiguration:GetColor('ControlPanelButtonsColor'), nil, 0, 6, 'right-top');
		controlPanelButtonsColorButton:SetOnClick(selectColorButtonClick);
		this:AddComponent(controlPanelButtonsColorButton);

		controlPanelPowerButtonColorLabel = Label('Control panel power button color:', nil, nil, 0, 7, 'left-top');
		this:AddComponent(controlPanelPowerButtonColorLabel);

		controlPanelPowerButtonColorButton = Button(' ', colorConfiguration:GetColor('ControlPanelPowerButtonColor'), nil, 0, 7, 'right-top');
		controlPanelPowerButtonColorButton:SetOnClick(selectColorButtonClick);
		this:AddComponent(controlPanelPowerButtonColorButton);

		timeTextColorLabel = Label('Time text color:', nil, nil, 0, 8, 'left-top');
		this:AddComponent(timeTextColorLabel);

		timeTextColorButton = Button(' ', colorConfiguration:GetColor('TimeTextColor'), nil, 0, 8, 'right-top');
		timeTextColorButton:SetOnClick(selectColorButtonClick);
		this:AddComponent(timeTextColorButton);

		systemButtonsColorLabel = Label('System buttons color:', nil, nil, 0, 9, 'left-top');
		this:AddComponent(systemButtonsColorLabel);

		systemButtonsColorButton = Button(' ', colorConfiguration:GetColor('SystemButtonsColor'), nil, 0, 9, 'right-top');
		systemButtonsColorButton:SetOnClick(selectColorButtonClick);
		this:AddComponent(systemButtonsColorButton);

		systemButtonsTextColorLabel = Label('System buttons text color:', nil, nil, 0, 10, 'left-top');
		this:AddComponent(systemButtonsTextColorLabel);

		systemButtonsTextColorButton = Button(' ', colorConfiguration:GetColor('SystemButtonsTextColor'), nil, 0, 10, 'right-top');
		systemButtonsTextColorButton:SetOnClick(selectColorButtonClick);
		this:AddComponent(systemButtonsTextColorButton);

		systemLabelsTextColorLabel = Label('System labels text color:', nil, nil, 0, 11, 'left-top');
		this:AddComponent(systemLabelsTextColorLabel);

		systemLabelsTextColorButton = Button(' ', colorConfiguration:GetColor('SystemLabelsTextColor'), nil, 0, 11, 'right-top');
		systemLabelsTextColorButton:SetOnClick(selectColorButtonClick);
		this:AddComponent(systemLabelsTextColorButton);	

		systemEditsBackgroundColorLabel = Label('System edits background color:', nil, nil, 0, 12, 'left-top');
		this:AddComponent(systemEditsBackgroundColorLabel);

		systemEditsBackgroundColorButton = Button(' ', colorConfiguration:GetColor('SystemEditsBackgroundColor'), nil, 0, 12, 'right-top');
		systemEditsBackgroundColorButton:SetOnClick(selectColorButtonClick);
		this:AddComponent(systemEditsBackgroundColorButton);


		saveChangesButton = Button('Save changes', nil, nil, 0, 0, 'left-bottom');
		saveChangesButton:SetOnClick(saveChangesButtonClick);
		this:AddComponent(saveChangesButton);

		cancelButton = Button('Cancel', nil, nil, 0, 0, 'right-bottom');
		cancelButton:SetOnClick(cancelButtonClick);
		this:AddComponent(cancelButton);
	end

	local function constructor()
		colorConfiguration = System:GetColorConfiguration();

		initializeComponents();
	end

	constructor();
end)
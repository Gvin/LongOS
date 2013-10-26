local Window = Classes.Application.Window;
local Label = Classes.Components.Label;
local Button = Classes.Components.Button;
local QuestionDialog = Classes.System.Windows.QuestionDialog;


InterfaceConfigurationWindow = Class(Window, function(this, _application, _localizationManager)
	Window.init(this, _application, 'Interface configuration window', false);
	this:SetWidth(36);
	this:SetHeight(8);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local interfaceConfiguration;

	local saveChangesButton;
	local cancelButton;
	local defaultButton;

	local controlPanelPositionButton;	
	local controlPanelPositionLabel;

	local windowButtonsPositionButton;	
	local windowButtonsPositionLabel;

	local localizationManager;

	local controlPanelPosition;
	local windowButtonsPosition;
	
	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function updateConfiguration()		
		interfaceConfiguration:SetOption('ControlPanelPosition', controlPanelPosition);
		interfaceConfiguration:SetOption('WindowButtonsPosition', windowButtonsPosition);
	end		

	local function getLocalizationKey(_position)
		if (_position == 'top') then
			return 'InterfaceConfiguration.Labels.Top';
		elseif (_position == 'bottom') then
			return 'InterfaceConfiguration.Labels.Bottom';
		elseif (_position == 'left') then
			return 'InterfaceConfiguration.Labels.Left';
		elseif (_position == 'right') then
			return 'InterfaceConfiguration.Labels.Right';
		end

		return nil;
	end

	local function controlPanelPositionButtonClick(_sender, _eventArgs)		
		if (controlPanelPosition == 'top') then	
			controlPanelPosition = 'bottom';	
		else
			controlPanelPosition = 'top'
		end
		controlPanelPositionButton:SetText(localizationManager:GetLocalizedString(getLocalizationKey(controlPanelPosition)));

		updateConfiguration();
	end

	local function windowButtonsPositionButtonClick(_sender, _eventArgs)		
		if (windowButtonsPosition == 'right') then
			windowButtonsPosition = 'left';	
		else
			windowButtonsPosition = 'right';
		end
		windowButtonsPositionButton:SetText(localizationManager:GetLocalizedString(getLocalizationKey(windowButtonsPosition)));

		updateConfiguration();
	end

	local function saveChangesButtonClick(_sender, _eventArgs)
		interfaceConfiguration:WriteConfiguration();
		this:Close();
	end

	local function cancelButtonClick(_sender, _eventArgs)
		interfaceConfiguration:ReadConfiguration();
		this:Close();
	end


	local function defaultDialogYes(sender, eventArgs)
		interfaceConfiguration:SetDefault();
		controlPanelPosition = interfaceConfiguration:GetOption('ControlPanelPosition');
		windowButtonsPosition = interfaceConfiguration:GetOption('WindowButtonsPosition');
		controlPanelPositionButton:SetText(localizationManager:GetLocalizedString(getLocalizationKey(controlPanelPosition)));
		windowButtonsPositionButton:SetText(localizationManager:GetLocalizedString(getLocalizationKey(windowButtonsPosition)));				
	end

	local function defaultButtonClick(_sender, _eventArgs)
		local defaultDialog = QuestionDialog(this:GetApplication(), localizationManager:GetLocalizedString('DefaultDialog.Title'), localizationManager:GetLocalizedString('DefaultDialog.Text'));
		defaultDialog:AddOnYesEventHandler(defaultDialogYes);
		defaultDialog:ShowModal();		
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()

		controlPanelPositionButton = Button(localizationManager:GetLocalizedString(getLocalizationKey(controlPanelPosition)), nil, nil, 0, 1, 'right-top');
		controlPanelPositionButton:AddOnClickEventHandler(controlPanelPositionButtonClick);			
		this:AddComponent(controlPanelPositionButton);

		controlPanelPositionLabel = Label(localizationManager:GetLocalizedString('InterfaceConfiguration.Labels.ControlPanelPosition'), nil, nil, 0, 1, 'left-top');
		this:AddComponent(controlPanelPositionLabel);

		windowButtonsPositionButton = Button(localizationManager:GetLocalizedString(getLocalizationKey(windowButtonsPosition)), nil, nil, 0, 3, 'right-top');
		windowButtonsPositionButton:AddOnClickEventHandler(windowButtonsPositionButtonClick);			
		this:AddComponent(windowButtonsPositionButton);	

		windowButtonsPositionLabel = Label(localizationManager:GetLocalizedString('InterfaceConfiguration.Labels.WindowButtonsPosition'), nil, nil, 0, 3, 'left-top');
		this:AddComponent(windowButtonsPositionLabel);

		saveChangesButton = Button(System:GetLocalizedString('Action.SaveChanges'), nil, nil, 0, 0, 'left-bottom');
		saveChangesButton:AddOnClickEventHandler(saveChangesButtonClick);
		this:AddComponent(saveChangesButton);

		defaultButton = Button(System:GetLocalizedString('Action.SetDefault'), nil, nil, saveChangesButton:GetText():len() + 1, 0, 'left-bottom');
		defaultButton:AddOnClickEventHandler(defaultButtonClick);
		this:AddComponent(defaultButton);

		cancelButton = Button(System:GetLocalizedString('Action.Cancel'), nil, nil, 0, 0, 'right-bottom');
		cancelButton:AddOnClickEventHandler(cancelButtonClick);
		this:AddComponent(cancelButton);

		this:SetWidth(math.max(controlPanelPositionLabel:GetWidth() + controlPanelPositionButton:GetWidth() + 2, windowButtonsPositionLabel:GetWidth() + windowButtonsPositionButton:GetWidth() + 2));
	end

	local function constructor(_localizationManager)
		localizationManager = _localizationManager;

		this:SetTitle(localizationManager:GetLocalizedString('InterfaceConfiguration.Title'));

		interfaceConfiguration = System:GetInterfaceConfiguration();

		controlPanelPosition = interfaceConfiguration:GetOption('ControlPanelPosition');
		windowButtonsPosition = interfaceConfiguration:GetOption('WindowButtonsPosition');

		initializeComponents();
	end

	constructor(_localizationManager);
end)
InterfaceConfigurationWindow = Class(Window, function(this, _application)
	Window.init(this, _application, 'Interface configuration window', false);
	this:SetIsModal(true);
	this:SetTitle('Interface configuration');
	this:SetX(7);
	this:SetY(3);
	this:SetWidth(36);
	this:SetHeight(13);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local interfaceConfiguration;

	local controlPanelPositionButton;	
	local controlPanelPositionLabel;

	local windowButtonsPositionButton;	
	local windowButtonsPositionLabel;


	
	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function updateConfiguration()		
		interfaceConfiguration:SetOption('ControlPanelPosition', controlPanelPositionButton:GetText());
		interfaceConfiguration:SetOption('WindowButtonsPosition', windowButtonsPositionButton:GetText());
	end		


	local function controlPanelPositionButtonClick(_sender, _eventArgs)		
		if (controlPanelPositionButton:GetText() == 'top') then		
			controlPanelPositionButton:SetText('bottom');
		else
			controlPanelPositionButton:SetText('top');
		end
		updateConfiguration();
	end

	local function windowButtonsPositionButtonClick(_sender, _eventArgs)		
		if (windowButtonsPositionButton:GetText() == 'right') then		
			windowButtonsPositionButton:SetText('left');
		else
			windowButtonsPositionButton:SetText('right');
		end
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

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()

		controlPanelPositionButton = Button(interfaceConfiguration:GetOption('ControlPanelPosition'), nil, nil, 0, 1, 'right-top');
		controlPanelPositionButton:SetOnClick(controlPanelPositionButtonClick);			
		this:AddComponent(controlPanelPositionButton);

		controlPanelPositionLabel = Label('Control Panel Position:', nil, nil, 0, 1, 'left-top');
		this:AddComponent(controlPanelPositionLabel);

		windowButtonsPositionButton = Button(interfaceConfiguration:GetOption('WindowButtonsPosition'), nil, nil, 0, 3, 'right-top');
		windowButtonsPositionButton:SetOnClick(windowButtonsPositionButtonClick);			
		this:AddComponent(windowButtonsPositionButton);	

		windowButtonsPositionLabel = Label('Window Buttons Position:', nil, nil, 0, 3, 'left-top');
		this:AddComponent(windowButtonsPositionLabel);

		saveChangesButton = Button('Save changes', nil, nil, 0, 0, 'left-bottom');
		saveChangesButton:SetOnClick(saveChangesButtonClick);
		this:AddComponent(saveChangesButton);

		cancelButton = Button('Cancel', nil, nil, 0, 0, 'right-bottom');
		cancelButton:SetOnClick(cancelButtonClick);
		this:AddComponent(cancelButton);
	end

	local function constructor()
		interfaceConfiguration = System:GetInterfaceConfiguration();
		initializeComponents();
	end

	constructor();
end)
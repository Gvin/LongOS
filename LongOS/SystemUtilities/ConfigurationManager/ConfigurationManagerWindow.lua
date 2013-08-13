ConfigurationManagerWindow = Class(Window, function(this, _application)
	Window.init(this, _application, 'Configuration window', false);	
	this:SetTitle('Configuration');
	this:SetX(10);
	this:SetY(3);
	this:SetWidth(30);
	this:SetHeight(10);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);

	
	local colorConfigurationButton;
	local mouseConfigurationButton;
	local interfaceConfigurationButton;
	

	local function colorConfigurationButtonClick(_sender, _eventArgs)
		local colorWindow = ColorConfigurationWindow(_application);
		colorWindow:Show();		
	end	

	local function mouseConfigurationButtonClick(_sender, _eventArgs)
		local mouseWindow = MouseConfigurationWindow(_application);
		mouseWindow:Show();		
	end	

	local function interfaceConfigurationButtonClick (_sender, _eventArgs)
		local interfaceWindow = InterfaceConfigurationWindow(_application);
		interfaceWindow:Show();		
	end	

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()		
		local colorConfigurationButton = Button('Open color configuration    ', nil, nil, 0, 1, 'left-top');
		colorConfigurationButton:SetOnClick(colorConfigurationButtonClick);
		this:AddComponent(colorConfigurationButton);
	
		local mouseConfigurationButton = Button('Open mouse configuration    ', nil, nil, 0, 3, 'left-top');
		mouseConfigurationButton:SetOnClick(mouseConfigurationButtonClick);
		this:AddComponent(mouseConfigurationButton);	

		interfaceConfigurationButton = Button('Open interface configuration', nil, nil, 0, 5, 'left-top');
		interfaceConfigurationButton:SetOnClick(interfaceConfigurationButtonClick);
		this:AddComponent(interfaceConfigurationButton);
	end

	local function constructor()
		initializeComponents();
	end

	constructor();

end)
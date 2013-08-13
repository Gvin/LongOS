MouseConfigurationWindow = Class(Window, function(this, _application)
	Window.init(this, _application, 'Mouse configuration window', false);
	this:SetIsModal(true);
	this:SetTitle('Mouse configuration');
	this:SetX(7);
	this:SetY(3);
	this:SetWidth(36);
	this:SetHeight(7);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local mouseConfiguration;


	local doubleClickEdit;	

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------		

	local function saveChangesButtonClick(_sender, _eventArgs)
		local doubleClick = tonumber(doubleClickEdit.Text);		
		if (doubleClick ~= nil ) then
			mouseConfiguration:SetOption('DoubleClickSpeed', doubleClickEdit.Text);
			mouseConfiguration:WriteConfiguration();
			this:Close();			
		else
			local errorWindow = MessageWindow(this:GetApplication(), 'Not a number', 'Double click speed must be a number');			
			errorWindow:Show();	
		end
		
	end

	local function cancelButtonClick(_sender, _eventArgs)
		mouseConfiguration:ReadConfiguration();
		this:Close();
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		
		doubleClickLabel = Label('Double click speed', nil, nil, 1, 1, 'left-top');
		this:AddComponent(doubleClickLabel);
	
		doubleClickEdit = Edit(10, nil, nil, 22, 1, 'left-top');	
		doubleClickEdit.Text = mouseConfiguration:GetOption('DoubleClickSpeed');					
		doubleClickEdit:SetFocus(true);
		this:AddComponent(doubleClickEdit);

		saveChangesButton = Button('Save changes', nil, nil, 0, -1, 'left-bottom');
		saveChangesButton:SetOnClick(saveChangesButtonClick);
		this:AddComponent(saveChangesButton);

		cancelButton = Button('Cancel', nil, nil, -6, -1, 'right-bottom');
		cancelButton:SetOnClick(cancelButtonClick);
		this:AddComponent(cancelButton);
	end

	local function constructor()
		mouseConfiguration = System:GetMouseConfiguration();
		initializeComponents();
	end

	constructor();
end)
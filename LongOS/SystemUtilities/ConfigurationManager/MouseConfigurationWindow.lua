local Window = Classes.Application.Window;
local Label = Classes.Components.Label;
local Button = Classes.Components.Button;
local Edit = Classes.Components.Edit;
local MessageWindow = Classes.System.Windows.MessageWindow;
local QuestionDialog = Classes.System.Windows.QuestionDialog;


MouseConfigurationWindow = Class(Window, function(this, _application)
	Window.init(this, _application, 'Mouse configuration window', false);
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

	local saveChangesButton;
	local cancelButton;
	local defaultButton;

	local doubleClickEdit;	

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------		

	
	

	local function saveChangesButtonClick(_sender, _eventArgs)
		mouseConfiguration:SetOption('DoubleClickSpeed', doubleClickEdit:GetText());
		mouseConfiguration:WriteConfiguration();
		this:Close();				
	end

	local function cancelButtonClick(_sender, _eventArgs)
		mouseConfiguration:ReadConfiguration();
		this:Close();
	end



	local function defaultDialogYes(sender, eventArgs)
		mouseConfiguration:SetDefault();
		doubleClickEdit:SetText(mouseConfiguration:GetOption('DoubleClickSpeed'));
	end

	local function defaultButtonClick(_sender, _eventArgs)
		local defaultDialog = QuestionDialog(this:GetApplication(), 'Set default?', 'Do you really want to set default configuratin?');
		defaultDialog:AddOnYesEventHandler(defaultDialogYes);
		defaultDialog:ShowModal();		
	end


	local function editTextChanged(_sender, _eventArgs)
		local  textBefore = _eventArgs.TextBefore;
		local  textAfter = _eventArgs.TextAfter;		
		
		local doubleClickSpeed = tonumber(textAfter);

		if ( doubleClickSpeed == nil or doubleClickSpeed <= 0) then
			if ( textAfter ~= '' ) then
				_sender:SetText(textBefore);
			end
		end	
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		
		doubleClickLabel = Label('Double click speed', nil, nil, 1, 1, 'left-top');
		this:AddComponent(doubleClickLabel);
	
		doubleClickEdit = Edit(10, nil, nil, 22, 1, 'left-top');	
		doubleClickEdit:AddOnTextChangedEventHandler(editTextChanged);
		doubleClickEdit:SetText(mouseConfiguration:GetOption('DoubleClickSpeed'));					
		doubleClickEdit:SetFocus(true);
		this:AddComponent(doubleClickEdit);

		saveChangesButton = Button('Save changes', nil, nil, 0, 0, 'left-bottom');
		saveChangesButton:AddOnClickEventHandler(saveChangesButtonClick);
		this:AddComponent(saveChangesButton);

		defaultButton = Button('Set default', nil, nil, 14, 0, 'left-bottom');
		defaultButton:AddOnClickEventHandler(defaultButtonClick);
		this:AddComponent(defaultButton);

		cancelButton = Button('Cancel', nil, nil, 0, 0, 'right-bottom');
		cancelButton:AddOnClickEventHandler(cancelButtonClick);
		this:AddComponent(cancelButton);
	end

	local function constructor()
		mouseConfiguration = System:GetMouseConfiguration();
		initializeComponents();
	end

	constructor();
end)
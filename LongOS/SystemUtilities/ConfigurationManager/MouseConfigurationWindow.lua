local Window = Classes.Application.Window;
local Label = Classes.Components.Label;
local Button = Classes.Components.Button;
local Edit = Classes.Components.Edit;
local MessageWindow = Classes.System.Windows.MessageWindow;
local QuestionDialog = Classes.System.Windows.QuestionDialog;


MouseConfigurationWindow = Class(Window, function(this, _application, _localizationManager)
	Window.init(this, _application, 'Mouse configuration window', false);
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

	local localizationManager;	

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------		

	local function saveChangesButtonClick(_sender, _eventArgs)
		if (doubleClickEdit:GetText():len() > 0) then
			mouseConfiguration:SetOption('DoubleClickSpeed', doubleClickEdit:GetText());
			mouseConfiguration:WriteConfiguration();
			this:Close();
		end			
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
		local defaultDialog = QuestionDialog(this:GetApplication(), localizationManager:GetLocalizedString('DefaultDialog.Title'), localizationManager:GetLocalizedString('DefaultDialog.Text'));
		defaultDialog:AddOnYesEventHandler(defaultDialogYes);
		defaultDialog:ShowModal();		
	end

	local function editTextFilter(_char)
		return (tonumber(_char) ~= nil and _char ~= '-' and _char ~= '.');
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		
		doubleClickLabel = Label(localizationManager:GetLocalizedString('MouseConfiguration.Labels.DoubleClickSpeed'), nil, nil, 1, 1, 'left-top');
		this:AddComponent(doubleClickLabel);
	
		doubleClickEdit = Edit(3, nil, nil, 0, 1, 'right-top');	
		doubleClickEdit:SetFilter(editTextFilter);
		doubleClickEdit:SetText(mouseConfiguration:GetOption('DoubleClickSpeed'));					
		doubleClickEdit:SetFocus(true);
		this:AddComponent(doubleClickEdit);

		saveChangesButton = Button(System:GetLocalizedString('Action.SaveChanges'), nil, nil, 0, 0, 'left-bottom');
		saveChangesButton:AddOnClickEventHandler(saveChangesButtonClick);
		this:AddComponent(saveChangesButton);

		defaultButton = Button(System:GetLocalizedString('Action.SetDefault'), nil, nil, saveChangesButton:GetText():len() + 1, 0, 'left-bottom');
		defaultButton:AddOnClickEventHandler(defaultButtonClick);
		this:AddComponent(defaultButton);

		cancelButton = Button(System:GetLocalizedString('Action.Cancel'), nil, nil, 0, 0, 'right-bottom');
		cancelButton:AddOnClickEventHandler(cancelButtonClick);
		this:AddComponent(cancelButton);
	end

	local function constructor(_localizationManager)
		mouseConfiguration = System:GetMouseConfiguration();
		localizationManager = _localizationManager;

		this:SetTitle(localizationManager:GetLocalizedString('MouseConfiguration.Title'));

		initializeComponents();
	end

	constructor(_localizationManager);
end)
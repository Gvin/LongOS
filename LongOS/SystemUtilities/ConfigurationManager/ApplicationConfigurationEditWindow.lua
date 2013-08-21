local Window = Classes.Application.Window;
local Label = Classes.Components.Label;
local Button = Classes.Components.Button;
local Edit = Classes.Components.Edit;
local EventHandler = Classes.System.EventHandler;
local CheckBox = Classes.Components.CheckBox;	
local MessageWindow = Classes.System.Windows.MessageWindow;

ApplicationConfigurationEditWindow = Class(Window, function(this, _application, _applicationData)
	Window.init(this, _application, 'Applications configuration edit window', false);
	this:SetX(4);
	this:SetY(3);
	this:SetWidth(44);
	this:SetHeight(11);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local onSave;

	local saveChangesButton;
	local cancelButton;

	local nameEdit;
	local nameLabel;
	local pathEdit;
	local pathLabel;
	local terminalCheckBox;
	local terminalLabel;


	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------


	function this:AddOnSaveEventHandler(_value)
		onSave:AddHandler(_value);
	end


	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function saveChangesButtonClick(_sender, _eventArgs)			
		local name = nameEdit:GetText();
		if (#name == 0) then
			local errorWindow = MessageWindow(this:GetApplication(), 'Empty name', 'Application name should be entered');			
			errorWindow:ShowModal();	
		else
			local path = pathEdit:GetText();

			if (#path == 0) then
				local errorWindow = MessageWindow(this:GetApplication(), 'Empty path', 'Application path should be entered');			
				errorWindow:ShowModal();	
			elseif (fs.exists(path) and fs.isDir(path) == false ) then
				local applicationData = {};
				table.insert(applicationData,name);
				table.insert(applicationData,path);
				local terminal = 'false';
				if (terminalCheckBox:GetChecked()) then
					terminal = 'true';
				end
				table.insert(applicationData,terminal);
				local eventArgs = {};
				eventArgs.ApplicationData = applicationData;		
				onSave:Invoke(this, eventArgs)	
				this:Close();			
			else
				local errorWindow = MessageWindow(this:GetApplication(), 'File not exist', 'File with path '..path..' not exist');			
				errorWindow:ShowModal();	
			end
		end
	end

	local function cancelButtonClick(_sender, _eventArgs)		
		this:Close();
	end	


	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents(_applicationData)	

		nameLabel = Label('Name', nil, nil, 1, 1, 'left-top');
		this:AddComponent(nameLabel);

		nameEdit = Edit(this:GetWidth() - 4, nil, nil, 1, 2, 'left-top');		
		nameEdit:SetFocus(true);
		this:AddComponent(nameEdit);

		pathLabel = Label('Path', nil, nil, 1, 3, 'left-top');
		this:AddComponent(pathtLabel);

		pathEdit = Edit(this:GetWidth() - 4, nil, nil, 1, 4, 'left-top');
		this:AddComponent(pathEdit);

		terminalCheckBox = CheckBox(nil, nil, 1, 6, 'left-top');
		this:AddComponent(terminalCheckBox);

		terminalLabel = Label('Terminal', nil, nil, 3, 6, 'left-top');
		this:AddComponent(terminalLabel);


		saveChangesButton = Button('Save changes', nil, nil, 0, 0, 'left-bottom');
		saveChangesButton:AddOnClickEventHandler(saveChangesButtonClick);
		this:AddComponent(saveChangesButton);

		cancelButton = Button('Cancel', nil, nil, 0, 0, 'right-bottom');
		cancelButton:AddOnClickEventHandler(cancelButtonClick);
		this:AddComponent(cancelButton);		
	
	end

	local function constructor(_applicationData)
		initializeComponents();		

		onSave = EventHandler();

		if (_applicationData == nil) then
			this:SetTitle('App application configuration');
		else
			this:SetTitle('Edit application configuration');	

			nameEdit:SetText(_applicationData[1]);
			pathEdit:SetText(_applicationData[2]);
			if (_applicationData[3] == 'true') then
				terminalCheckBox:SetChecked(true);			
			end
		end
 	
	end

	constructor(_applicationData);
end)
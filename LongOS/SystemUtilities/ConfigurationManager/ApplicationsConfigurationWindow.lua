local Window = Classes.Application.Window;
local Label = Classes.Components.Label;
local Button = Classes.Components.Button;
local Edit = Classes.Components.Edit;
local ListBox = Classes.Components.ListBox;
local MessageWindow = Classes.System.Windows.MessageWindow;
local QuestionDialog = Classes.System.Windows.QuestionDialog;

ApplicationsConfigurationWindow = Class(Window, function(this, _application, _localizationManager)
	Window.init(this, _application, 'Applications configuration window', false);
	this:SetWidth(34);
	this:SetHeight(17);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local applicationsConfiguration;
	local controlPanel;

	local listBox;

	local saveChangesButton;
	local cancelButton;
	local defaultButton;

	local upButton;
	local downButton;

	local editButton;
	local addButton;
	local removeButton;

	local localizationManager;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function swapData(appData1, appData2)
		return appData2,appData1;
	end

	local function drawData()
		local data = applicationsConfiguration:GetApplicationsData();
		local selectedIndex = listBox:GetSelectedIndex();
		listBox:Clear();
		for i = 1, #data do
			listBox:AddItem(data[i][1]);		
		end	
		if (selectedIndex ~= -1) then
			listBox:SetSelectedIndex(selectedIndex);
		end
	end		

	local function saveChangesButtonClick(_sender, _eventArgs)
		applicationsConfiguration:WriteConfiguration();
		controlPanel:RefreshApplications();		
		this:Close();			

	end

	local function cancelButtonClick(_sender, _eventArgs)
		applicationsConfiguration:ReadConfiguration();
		controlPanel:RefreshApplications();
		this:Close();
	end

	local function upButtonClick(_sender, _eventArgs)
		local selectedIndex = listBox:GetSelectedIndex();
		if (selectedIndex > 1) then
			local data = applicationsConfiguration:GetApplicationsData();
			data[selectedIndex],data[selectedIndex - 1] = swapData(data[selectedIndex],data[selectedIndex - 1]);		
			applicationsConfiguration:SetApplicationsData(data);
			listBox:SetSelectedIndex(selectedIndex - 1);		
			drawData();
			controlPanel:RefreshApplications();
		end
	end

	local function downButtonClick(_sender, _eventArgs)
		local selectedIndex = listBox:GetSelectedIndex();
		if (selectedIndex < listBox:GetCount()) then
			local data = applicationsConfiguration:GetApplicationsData();
			data[selectedIndex],data[selectedIndex + 1] = swapData(data[selectedIndex],data[selectedIndex + 1]);		
			applicationsConfiguration:SetApplicationsData(data);
			listBox:SetSelectedIndex(selectedIndex + 1);		
			drawData();
			controlPanel:RefreshApplications();
		end	
	end


	local function editOnSave(_sender, _eventArgs)
		appData = _eventArgs.ApplicationData;
		local data = applicationsConfiguration:GetApplicationsData();
		local selectedIndex = listBox:GetSelectedIndex();
		if (selectedIndex >= 1) then
			data[selectedIndex] = appData;
			drawData();
			controlPanel:RefreshApplications();
		end
	end

	local function editButtonClick(_sender, _eventArgs)
		local selectedIndex = listBox:GetSelectedIndex();
		if (selectedIndex >= 1) then
			local data = applicationsConfiguration:GetApplicationsData();
			editAppWindow = ApplicationConfigurationEditWindow(this:GetApplication(), data[selectedIndex], localizationManager);
			editAppWindow:AddOnSaveEventHandler(editOnSave);
			editAppWindow:ShowModal();
		end
	end

	local function addOnSave(_sender, _eventArgs)
		appData = _eventArgs.ApplicationData;
		local data = applicationsConfiguration:GetApplicationsData();
		table.insert(data,appData);
		drawData();
		controlPanel:RefreshApplications();	
	end

	local function addButtonClick(_sender, _eventArgs)
		addAppWindow = ApplicationConfigurationEditWindow(this:GetApplication(), nil, localizationManager);
		addAppWindow:AddOnSaveEventHandler(addOnSave);
		addAppWindow:ShowModal();		
	end

	local function removeButtonClick(_sender, _eventArgs)
		local data = applicationsConfiguration:GetApplicationsData();
		local selectedIndex = listBox:GetSelectedIndex();
		if (selectedIndex >= 1) then
			table.remove(data,selectedIndex);
			listBox:RemoveItemAt(selectedIndex)
			drawData();
			controlPanel:RefreshApplications();	
		end
	end


	local function defaultDialogYes(sender, eventArgs)
		applicationsConfiguration:SetDefault();
		drawData();		
		controlPanel:RefreshApplications();
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

		listBox = ListBox(18,12,nil,nil,1,1,'left-top');
		this:AddComponent(listBox);

		saveChangesButton = Button(System:GetLocalizedString('Action.SaveChanges'), nil, nil, 0, 0, 'left-bottom');
		saveChangesButton:AddOnClickEventHandler(saveChangesButtonClick);
		this:AddComponent(saveChangesButton);

		defaultButton = Button(System:GetLocalizedString('Action.SetDefault'), nil, nil, saveChangesButton:GetText():len() + 1, 0, 'left-bottom');
		defaultButton:AddOnClickEventHandler(defaultButtonClick);
		this:AddComponent(defaultButton);

		cancelButton = Button(System:GetLocalizedString('Action.Cancel'), nil, nil, 0, 0, 'right-bottom');
		cancelButton:AddOnClickEventHandler(cancelButtonClick);
		this:AddComponent(cancelButton);

		upButton = Button('^', nil, nil, 21, 5, 'left-top');
		upButton:AddOnClickEventHandler(upButtonClick);
		this:AddComponent(upButton);

		downButton = Button('V', nil, nil, 21, 7, 'left-top');
		downButton:AddOnClickEventHandler(downButtonClick);
		this:AddComponent(downButton);

		addButton = Button(System:GetLocalizedString('Action.Add'), nil, nil, 1, 4, 'right-top');
		addButton:AddOnClickEventHandler(addButtonClick);
		this:AddComponent(addButton);

		editButton = Button(System:GetLocalizedString('Action.Edit'), nil, nil, 1, 6, 'right-top');
		editButton:AddOnClickEventHandler(editButtonClick);
		this:AddComponent(editButton);		

		removeButton = Button(System:GetLocalizedString('Action.Remove'), nil, nil, 1, 8, 'right-top');
		removeButton:AddOnClickEventHandler(removeButtonClick);
		this:AddComponent(removeButton);
	end

	local function constructor(_localizationManager)
		applicationsConfiguration = System:GetApplicationsConfiguration();
		controlPanel = System:GetControlPanel();
		localizationManager = _localizationManager;

		this:SetTitle(localizationManager:GetLocalizedString('ApplicationsConfiguration.Title'));

		initializeComponents();		
		drawData();	
	end

	constructor(_localizationManager);
end)
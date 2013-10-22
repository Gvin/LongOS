local Window = Classes.Application.Window;
local Label = Classes.Components.Label;
local Button = Classes.Components.Button;
local ProgressBar = Classes.Components.ProgressBar;

local QuestionDialog = Classes.System.Windows.QuestionDialog;
local MessageWindow = Classes.System.Windows.MessageWindow;

local LocalizationManager = Classes.System.Localization.LocalizationManager;

UpdateSystemWindow = Class(Window, function(this, _application)
	Window.init(this, _application, 'Update System window', false);	
	this:SetTitle('Updating system');
	this:SetWidth(26);
	this:SetHeight(8);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);	


	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------


	local updateButton;
	local currentVersionLabel;
	local lastVersionLabel;

	local lastVersion;

	local systemUpdater;
	local checkThread;

	local localizationManager;

	----------------------------------------------------
	---Window Event--------------------------
	----------------------------------------------------	

	local function updateDialogYes(sender, eventArgs)
		local downloadWindow = DownloadWindow(this:GetApplication(),systemUpdater);		
		downloadWindow:ShowModal();
	end

	local function getLastVersion()
		lastVersion = systemUpdater:GetLastVersion();
	end

	local function checkThreadOnStop()

		updateButton:SetVisible(true);

		local currentVersion = System:GetCurrentVersion();

		if (lastVersion == nil) then
			local updateErrorWindow = MessageWindow(this:GetApplication(), localizationManager:GetLocalizedString('Errors.UpdateSystemWindow.UpdateError.Title'), localizationManager:GetLocalizedString('Errors.UpdateSystemWindow.UpdateError.NoLastVersion'));
			updateErrorWindow:ShowModal();
			return;
		end

		lastVersionLabel:SetText(string.format(localizationManager:GetLocalizedString('UpdateSystemWindow.Labels.LastVersion'), lastVersion));		

		if (lastVersion == currentVersion) then
			local messageWindow = MessageWindow(this:GetApplication(), localizationManager:GetLocalizedString('Messages.UpdateSystemWindow.UpdateNotRequired.Title'), localizationManager:GetLocalizedString('Messages.UpdateSystemWindow.UpdateNotRequired.Text'));
			messageWindow:ShowModal();
			return;
		end

		local updateDialog = QuestionDialog(this:GetApplication(), localizationManager:GetLocalizedString('Messages.UpdateSystemWindow.NewVersionAvailable.Title'), string.format(localizationManager:GetLocalizedString('Messages.UpdateSystemWindow.NewVersionAvailable.Text'), lastVersion));
		updateDialog:AddOnYesEventHandler(updateDialogYes);
		updateDialog:ShowModal();
	end	

	local function checkForUpdate()
		updateButton:SetVisible(false);
		if (http == nil) then
			local updateErrorWindow = MessageWindow(this:GetApplication(), localizationManager:GetLocalizedString('Errors.UpdateSystemWindow.UpdateError.Title'), localizationManager:GetLocalizedString('Errors.UpdateSystemWindow.UpdateError.HttpNotEnabled'));
			updateErrorWindow:ShowModal();
			return;
		end
		systemUpdater = SystemUpdater();
		checkThread = Classes.Application.Thread(_application, getLastVersion);
		checkThread:AddOnStopEventHandler(checkThreadOnStop);
		checkThread:Start();				
	end

	local function updateButtonClick(_sender, _eventArgs)		
		checkForUpdate();		
	end

	local function onShow(_sender, _eventArgs)
		checkForUpdate();	
	end


	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents(_logotypeName)	
		localizationManager = LocalizationManager(fs.combine(this:GetApplication():GetWorkingDirectory(), 'Localizations'), fs.combine(this:GetApplication():GetWorkingDirectory(), 'Localizations/default.xml'));
		localizationManager:ReadLocalization(System:GetSystemLocale());

		this:SetTitle(localizationManager:GetLocalizedString('UpdateSystemWindow.Title'));
		
		updateButton = Button(localizationManager:GetLocalizedString('UpdateSystemWindow.Buttons.CheckUpdates'), nil, nil, 1, 4, 'left-top');
		updateButton:AddOnClickEventHandler(updateButtonClick);
		this:AddComponent(updateButton);			

		local currentVersion = System:GetCurrentVersion();

		currentVersionLabel = Label(string.format(localizationManager:GetLocalizedString('UpdateSystemWindow.Labels.CurrentVersion'), currentVersion), nil, nil, 1, 1, 'left-top');		
		this:AddComponent(currentVersionLabel);

		lastVersionLabel = Label(string.format(localizationManager:GetLocalizedString('UpdateSystemWindow.Labels.LastVersion'), ''), nil, nil, 1, 2, 'left-top');		
		this:AddComponent(lastVersionLabel);

		this:AddOnShowEventHandler(onShow);

	end

	local function constructor()
		
		initializeComponents();		

	end

	constructor();

end)
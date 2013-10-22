local Window = Classes.Application.Window;
local Label = Classes.Components.Label;
local Button = Classes.Components.Button;
local ProgressBar = Classes.Components.ProgressBar;

local QuestionDialog = Classes.System.Windows.QuestionDialog;
local MessageWindow = Classes.System.Windows.MessageWindow;

local LocalizationManager = Classes.System.Localization.LocalizationManager;

DownloadWindow = Class(Window, function(this, _application, _systemUpdater)
	Window.init(this, _application, 'Download window', false);	
	this:SetTitle('Updating system');
	this:SetWidth(20);
	this:SetHeight(9);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);	


	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------


	local systemUpdater;
	local updateThread;

	local cancelButton;
	local progressBar;
	local statusLabel;

	local localizationManager;


	----------------------------------------------------
	---Window Event--------------------------
	----------------------------------------------------	


	local function rebootDialogYes(sender, eventArgs)
		System:Reboot();
	end


	
	function this:Draw(_videoBuffer)

		local currentCount,filesCount = systemUpdater:GetProgress();

		local percent = math.modf(currentCount/filesCount * 100);
	

		statusLabel:SetText(string.format(localizationManager:GetLocalizedString('DownloadWindow.Labels.StatusLabel'), currentCount..'/'..filesCount));

		progressBar:SetMaxValue(filesCount);
		progressBar:SetValue(currentCount);		

		if (updateThread:GetStatus() == 'dead') then
			local rebootDialog = QuestionDialog(this:GetApplication(), localizationManager:GetLocalizedString('Dialogs.DownloadWindow.RebootDialog.Title'), localizationManager:GetLocalizedString('Dialogs.DownloadWindow.RebootDialog.Text'));
			rebootDialog:AddOnYesEventHandler(rebootDialogYes);
			rebootDialog:ShowModal();
			this:Close();
		end
			
	end



	local function cancelDialogYes(sender, eventArgs)
		updateThread:Stop();	
		this:Close();
	end


	local function cancelButtonClick(_sender, _eventArgs)		

		local cancelDialog = QuestionDialog(this:GetApplication(), localizationManager:GetLocalizedString('Dialogs.DownloadWindow.CancelDialog.Title'), localizationManager:GetLocalizedString('Dialogs.DownloadWindow.CancelDialog.Text'));
		cancelDialog:AddOnYesEventHandler(cancelDialogYes);
		cancelDialog:ShowModal();	
		
	end


	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents(_logotypeName)	

		localizationManager = LocalizationManager(fs.combine(this:GetApplication():GetWorkingDirectory(), 'Localizations'), fs.combine(this:GetApplication():GetWorkingDirectory(), 'Localizations/default.xml'));
		localizationManager:ReadLocalization(System:GetSystemLocale());

		this:SetTitle(localizationManager:GetLocalizedString('DownloadWindow.Title'));
		
		
		statusLabel = Label(string.format(localizationManager:GetLocalizedString('DownloadWindow.Labels.StatusLabel'), ''), nil, nil, 1, 1, 'left-top');		
		this:AddComponent(statusLabel);

		progressBar = ProgressBar(0, 1, 16, 1,3,'left-top');
		this:AddComponent(progressBar);

		cancelButton = Button(System:GetLocalizedString('Action.Cancel'), nil, nil, 1, 1, 'left-bottom');		
		cancelButton:AddOnClickEventHandler(cancelButtonClick);
		this:AddComponent(cancelButton);


		progressBar:SetShowPersent(true);


	end

	local function constructor()

		systemUpdater = _systemUpdater;
		initializeComponents();

		updateThread = Classes.Application.Thread(_application, systemUpdater.UpdateVersion);
		updateThread:Start();
		
		

	end

	constructor();

end)
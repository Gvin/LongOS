local Window = Classes.Application.Window;
local Label = Classes.Components.Label;
local Button = Classes.Components.Button;
local ProgressBar = Classes.Components.ProgressBar;

local QuestionDialog = Classes.System.Windows.QuestionDialog;
local MessageWindow = Classes.System.Windows.MessageWindow;


UpdateSystemWindow = Class(Window, function(this, _application, _systemUpdater)
	Window.init(this, _application, 'Update System window', false);	
	this:SetTitle('Updating system');
	this:SetX(11);
	this:SetY(4);
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


	----------------------------------------------------
	---Window Event--------------------------
	----------------------------------------------------	


	local function rebootDialogYes(sender, eventArgs)
		System:Reboot();
	end


	
	function this:Draw(_videoBuffer)

		local currentCount,filesCount = systemUpdater:GetProgress();

		local percent = math.modf(currentCount/filesCount * 100);

		statusLabel:SetText('Progress: '..currentCount..'/'..filesCount);

		progressBar:SetMaxValue(filesCount);
		progressBar:SetValue(currentCount);		

		if (updateThread:GetStatus() == 'dead') then
			local rebootDialog = QuestionDialog(this:GetApplication(), 'Update success', 'LongOS successfully updated.  Reboot is recommended. Reboot the system now?');
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

		local cancelDialog = QuestionDialog(this:GetApplication(), 'Cancel updating', 'Do you really want to cancel updating process? This operation can cause current system damadge.');
		cancelDialog:AddOnYesEventHandler(cancelDialogYes);
		cancelDialog:ShowModal();	
		
	end


	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents(_logotypeName)	
		
		statusLabel = Label('Progress:', nil, nil, 1, 1, 'left-top');		
		this:AddComponent(statusLabel);

		progressBar = ProgressBar(0, 1, 16, 1,3,'left-top');
		this:AddComponent(progressBar);

		cancelButton = Button('Cancel', nil, nil, 1, 1, 'left-bottom');		
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
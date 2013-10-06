local Window = Classes.Application.Window;
local Label = Classes.Components.Label;
local Button = Classes.Components.Button;

local Image = Classes.System.Graphics.Image;

local QuestionDialog = Classes.System.Windows.QuestionDialog;
local MessageWindow = Classes.System.Windows.MessageWindow;

AboutSystemWindow = Class(Window, function(this, _application)
	Window.init(this, _application, 'About System window', false);	
	this:SetTitle('About system');
	this:SetX(10);
	this:SetY(3);
	this:SetWidth(34);
	this:SetHeight(15);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);	


	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------


	local image;
	local updateButton;

	local systemUpdater;


	----------------------------------------------------
	---Window Event--------------------------
	----------------------------------------------------


	local drawImage = function(videoBuffer)
		local scrollY = vScrollBar:GetValue();
		local scrollX = hScrollBar:GetValue();
		local bottom = this:GetHeight() - 6 + scrollY;
		local right = this:GetWidth() - 4 + scrollX;
		if (bottom > image:GetHeight()) then
			bottom = image:GetHeight();
		end
		if (right > image:GetWidth()) then
			right = image:GetWidth();
		end
		for i = scrollY, bottom do
			for j = scrollX, right do
				local color = image:GetPixel(j, i);				
				videoBuffer:SetPixelColor(j + 1 - scrollX, i + 2 - scrollY, color);				
			end
		end
	end

	function this:Draw(_videoBuffer)
		for i = 1, image:GetWidth() do
			for j = 1, image:GetHeight() do
				local color = image:GetPixel(i, j);				
				_videoBuffer:SetPixelColor(i + 1, j + 1, color);
			end
		end
	end

	local function updateDialogYes(sender, eventArgs)
		local updateSystemWindow = UpdateSystemWindow(this:GetApplication(),systemUpdater);		
		updateSystemWindow:ShowModal();
	end

	local function updateButtonClick(_sender, _eventArgs)		

		systemUpdater = SystemUpdater();
		local lastVersion = systemUpdater:GetLastVersion();
		local currentVersion = System:GetCurrentVersion();

		if (lastVersion == nil) then

			local updateErrorWindow = MessageWindow(this:GetApplication(), 'Update error', "Cant't update Longos.");
			updateErrorWindow:ShowModal();
			return;
		end


		if (lastVersion == 'v'..currentVersion) then
			local messageWindow = MessageWindow(this:GetApplication(), 'Updating not required', "You are using the latest version of the LongOS. Updating not required.");
			messageWindow:ShowModal();
			return;
		end


		local updateDialog = QuestionDialog(this:GetApplication(), 'New version available', 'Version '..lastVersion..' is available. Download?');
		updateDialog:AddOnYesEventHandler(updateDialogYes);
		updateDialog:ShowModal();		

		
	end
	


	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents(_logotypeName)	

		if (_logotypeName ~= nil) then	
			image = Image(_logotypeName);
		end

	
		local currentVersionLabel = Label('LongOs v.'..System:GetCurrentVersion(), nil, nil, 14, 2, 'left-top');		
		this:AddComponent(currentVersionLabel);


		updateButton = Button('Check update ', nil, nil, 14, 3, 'left-top');
		updateButton:AddOnClickEventHandler(updateButtonClick);
		this:AddComponent(updateButton);

--		local currentVersionLabel = Label('LongOs v.'..System:GetCurrentVersion(),nil,nil,14,2,'left-top');
--		this:AddComponent(currentVersionLabel);		


		local id = os.getComputerID();
		local computerIdLabel = Label('ID:    '..id,nil,nil,2,9,'left-top');
		this:AddComponent(computerIdLabel);

		local label = os.getComputerLabel();
		if (label == nil) then 
			label = '';
		end		
		local computerLabelLabel = Label('Label: '..label,nil,nil,2,11,'left-top');
		this:AddComponent(computerLabelLabel);

		copyright = '@ Gvin, Biribitum,'
		local copyrightLabel = Label(copyright,nil,nil,14,5,'left-top');
		this:AddComponent(copyrightLabel);
		
		year = '2013'
		local yearLabel = Label(year,nil,nil,20,7,'left-top');
		this:AddComponent(yearLabel);


	end

	local function constructor()

		logotypeName = System:ResolvePath(this:GetApplication():GetWorkingDirectory()..'logotype.image');
		if ( not fs.exists(logotypeName)) then
			local errorWindow = MessageWindow(this:GetApplication(), 'File not exist', 'Can`t load logotype. File with name :"'..logotypeName..'" not exist');
			errorWindow:ShowModal();
			logotypeName = nil;
		end

		initializeComponents(logotypeName);
	end

	constructor();

end)
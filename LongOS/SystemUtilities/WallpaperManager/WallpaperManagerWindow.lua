local Window = Classes.Application.Window;
local Button = Classes.Components.Button;
local Label = Classes.Components.Label;
local EnterTextDialog = Classes.System.Windows.EnterTextDialog;
local MessageWindow = Classes.System.Windows.MessageWindow;

WallpaperManagerWindow = Class(Window, function(this, _application)
	Window.init(this, _application, 'Wallpaper manager', false);
	this:SetTitle('Wallpaper manager');
	this:SetX(5);
	this:SetY(3);
	this:SetWidth(40);
	this:SetHeight(8);
	this:SetAllowResize(false);
	this:SetAllowMaximize(false);

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local interfaceConfiguration;

	local saveChangesButton;
	local cancelButton;
	local browseButton;
	local currentWallpaperLabel;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:Draw(_videoBuffer)
		local wallpaperPath = interfaceConfiguration:GetOption('WallpaperFileName');
		local toPrint = wallpaperPath;
		if (toPrint:len() > 32) then
			toPrint = '...'..toPrint:sub(toPrint:len() - 32, toPrint:len());
		end

		local colorConfiguration = System:GetColorConfiguration();
		_videoBuffer:SetTextColor(colorConfiguration:GetColor('SystemLabelsTextColor'));
		_videoBuffer:SetBackgroundColor(colorConfiguration:GetColor('WindowColor'));
		_videoBuffer:WriteAt(2, 2, toPrint);
	end

	local function saveChangesButtonClick(_sender, _eventArgs)
		interfaceConfiguration:WriteConfiguration();
		System:ReadConfiguration();
		this:Close();
	end

	local function cancelButtonClick(_sender, _eventArgs)
		this:Close();
	end

	local function fileNameDialogOnOk(_sender, _eventArgs)
		local fileName = _eventArgs.Text;
		if (fs.exists(fileName) and stringExtAPI.endsWith(fileName, '.image')) then
			interfaceConfiguration:SetOption('WallpaperFileName', fileName);
		else
			local errorMessage = MessageWindow(this:GetApplication(), 'Invalid path', 'Invalid file path.');
			errorMessage:ShowModal();
		end
	end

	local function browseButtonClick(_sender, _eventArgs)
		local wallpaperPath = interfaceConfiguration:GetOption('WallpaperFileName');
		local fileNameDialog = EnterTextDialog(this:GetApplication(), 'Browse for wallpaper', "Enter new wallpaper's path.", wallpaperPath);
		fileNameDialog:AddOnOkEventHandler(fileNameDialogOnOk);
		fileNameDialog:ShowModal();
	end

	local function windowOnClose(_sender, _eventArgs)
		interfaceConfiguration:ReadConfiguration();
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()
		saveChangesButton = Button('Save changes', nil, nil, 0, 0, 'left-bottom');
		saveChangesButton:AddOnClickEventHandler(saveChangesButtonClick);
		this:AddComponent(saveChangesButton);

		cancelButton = Button('Cancel', nil, nil, 0, 0, 'right-bottom');
		cancelButton:AddOnClickEventHandler(cancelButtonClick);
		this:AddComponent(cancelButton);

		browseButton = Button('Browse', nil, nil, 20, 0, 'left-top');
		browseButton:AddOnClickEventHandler(browseButtonClick);
		this:AddComponent(browseButton);

		currentWallpaperLabel = Label('Current wallpaper:', nil, nil, 0, 0, 'left-top');
		this:AddComponent(currentWallpaperLabel);
	end

	local function constructor()
		interfaceConfiguration = System:GetInterfaceConfiguration();
		this:AddOnCloseEventHandler(windowOnClose);

		initializeComponents();
	end

	constructor();
end)
local EventHandler = Classes.System.EventHandler;
local Button = Classes.Components.Button;
local Label = Classes.Components.Label;
local Edit = Classes.Components.Edit;
local Window = Classes.Application.Window;

local MessageWindow = Classes.System.Windows.MessageWindow;


BiriPaintImageSizeDialog = Class(Window, function(this, _application, _title,_initialWidth, _initialHeight, _localizationManager)

	Window.init(this, _application, 'Paint new dialog', false);
	this:SetTitle(_title);
	this:SetWidth(30);
	this:SetHeight(9);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local onOk;
	local onCancel;

	local okButton;
	local cancelButton;
	local widthEdit;
	local widthLabel;
	local heightEdit;
	local heightLabel;

	local localizationManager;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this.AddOnOkEventHandler(_, _value)
		onOk:AddHandler(_value);
	end

	function this.AddOnCancelEventHandler(_, _value)
		onCancel:AddHandler(_value);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------
	
	local function okButtonClick(_sender, _eventArgs)
		local width = tonumber(widthEdit:GetText());
		local height = tonumber(heightEdit:GetText());
		if (width and height ~= nil ) then
			this:Close();
			local eventArgs = {};
			eventArgs.Width = width;
			eventArgs.Height = height;
			onOk:Invoke(this, eventArgs);				
		end
	end

	local function cancelButtonClick(_sender, _eventArgs)
		this:Close();
		onCancel:Invoke(this, { });
	end

	function this.ProcessKeyEvent(_, _key)
		if (keys.getName(_key) == 'enter') then
			okButtonClick(nil, nil);
		end
	end

	local function editNumberFilter(_char)
		return (tonumber(_char) ~= nil and _char ~= '-' and _char ~= '.');
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents(_initialWidth, _initialHeight)
		okButton = Button(System:GetLocalizedString('Action.Ok'), nil, nil, 0, 0, 'left-bottom');
		okButton:AddOnClickEventHandler(okButtonClick);
		this:AddComponent(okButton);

		cancelButton = Button(System:GetLocalizedString('Action.Cancel'), nil, nil, 0, 0, 'right-bottom');
		cancelButton:AddOnClickEventHandler(cancelButtonClick);
		this:AddComponent(cancelButton);

		widthLabel = Label(localizationManager:GetLocalizedString('NewImageDialog.Label.Width'), nil, nil, 1, 1, 'left-top');
		this:AddComponent(widthLabel);

		widthEdit = Edit(26, nil, nil, 1, 2, 'left-top');
		if (_initialWidth ~= nil) then
			widthEdit:SetText(_initialWidth);
		end
		widthEdit:SetFocus(true);
		widthEdit:SetFilter(editNumberFilter);
		this:AddComponent(widthEdit);

		heightLabel = Label(localizationManager:GetLocalizedString('NewImageDialog.Label.Height'), nil, nil, 1, 3, 'left-top');
		this:AddComponent(heightLabel);

		heightEdit = Edit(26, nil, nil, 1, 4, 'left-top');
		if (_initialHeight ~= nil) then
			heightEdit:SetText(_initialHeight);
		end
		heightEdit:SetFilter(editNumberFilter);

		this:AddComponent(heightEdit);
	end

	local function constructor(_application, _title, _initialWidth, _initialHeight, _localizationManager)
		onOk = EventHandler();
		onCancel = EventHandler();
		localizationManager = _localizationManager;

		initializeComponents(_initialWidth, _initialHeight);
	end

	constructor(_application, _title, _initialWidth, _initialHeight, _localizationManager);
end)
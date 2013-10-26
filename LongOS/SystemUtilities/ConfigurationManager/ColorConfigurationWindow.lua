local Window = Classes.Application.Window;
local Label = Classes.Components.Label;
local Button = Classes.Components.Button;
local ListBox = Classes.Components.ListBox;
local ColorPickerDialog = Classes.System.Windows.ColorPickerDialog;
local QuestionDialog = Classes.System.Windows.QuestionDialog;

ColorConfigurationWindow = Class(Window, function(this, _application, _localizationManager)
	Window.init(this, _application, 'Color configuration window', false);
	this:SetWidth(44);
	this:SetHeight(18);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local colorConfiguration;

	local colorLabel;
	local colorListBox;
	local selectColorButton;
	
	local saveChangesButton;
	local cancelButton;
	local defaultButton;

	local localizationManager;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function updateConfiguration()

	end

	local function colorListBoxSelectedIndexChanged(_sender, _eventArgs)
		local selectedIndex = colorListBox:GetSelectedIndex();
		local colorName = colorListBox:GetSelectedItem();
		colorLabel:SetText(localizationManager:GetLocalizedString('ColorConfiguration.Labels.Color')..colorName);			
		selectColorButton:SetBackgroundColor(colorConfiguration:GetColor(colorName) );

	end

	local function colorPickerOnOk(_sender, _eventArgs)

		local colorValue = _eventArgs.Color;
		local selectedIndex = colorListBox:GetSelectedIndex();
		local colorName = colorListBox:GetSelectedItem();
		selectColorButton:SetBackgroundColor(colorValue);
		colorConfiguration:SetColor(colorName, colorValue);		
	end

	local function selectColorButtonClick(_sender, _eventArgs)
		selectedButton = _sender;
		local picker = ColorPickerDialog(this:GetApplication());
		picker:AddOnOkEventHandler(colorPickerOnOk);
		picker:ShowModal();
	end

	local function saveChangesButtonClick(_sender, _eventArgs)
		colorConfiguration:WriteConfiguration();
		this:Close();
	end

	local function cancelButtonClick(_sender, _eventArgs)
		colorConfiguration:ReadConfiguration();
		this:Close();
	end

	function this:Draw(_videoBuffer)
		local x = selectColorButton:GetX() - 1 - this:GetX();
		local y = selectColorButton:GetY() - 1 - this:GetY();
		local width = selectColorButton:GetWidth();
		local height = selectColorButton:GetHeight();
		local textColor = colorConfiguration:GetColor('WindowBorderColor');
		local backgroungColor = colorConfiguration:GetColor('WindowColor');
		_videoBuffer:SetColorParameters(textColor,backgroungColor);
		_videoBuffer:WriteAt(x,y,'+');

		_videoBuffer:DrawBlock(x + 1,y,width,1,backgroungColor,'-');

		_videoBuffer:WriteAt(x + width + 1,y,'+');

		_videoBuffer:DrawBlock(x + 1 + width,y + 1,1,height,backgroungColor,'|');

		_videoBuffer:WriteAt(x + width + 1,y + height + 1,'+');

		_videoBuffer:DrawBlock(x + 1,y + 1 + height,width,1,backgroungColor,'-');

		_videoBuffer:WriteAt(x,y + height + 1,'+');

		_videoBuffer:DrawBlock(x,y + 1,1,height,backgroungColor,'|');

		
		
	end

	local function defaultDialogYes(sender, eventArgs)
		colorConfiguration:SetDefault();
		colorListBoxSelectedIndexChanged();
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
		colorLabel = Label(localizationManager:GetLocalizedString('ColorConfiguration.Labels.Color'), nil, nil, 1, 1, 'left-top');
		this:AddComponent(colorLabel);

		colorListBox = ListBox(23,12,nil,nil,1,2,'left-top');
		colorListBox:AddOnSelectedIndexChangedEventHandler(colorListBoxSelectedIndexChanged);	
		this:AddComponent(colorListBox);
	
		local selectColorLabel = Label(localizationManager:GetLocalizedString('ColorConfiguration.Labels.ColorSelection'), nil, nil, 0, 5, 'right-top');
		this:AddComponent(selectColorLabel);

		selectColorButton = Button('        ', nil, nil, 5, 7, 'right-top');
		selectColorButton:AddOnClickEventHandler(selectColorButtonClick);
		this:AddComponent(selectColorButton);


		saveChangesButton = Button(System:GetLocalizedString('Action.SaveChanges'), nil, nil, 0, 0, 'left-bottom');
		saveChangesButton:AddOnClickEventHandler(saveChangesButtonClick);
		this:AddComponent(saveChangesButton);

		cancelButton = Button(System:GetLocalizedString('Action.Cancel'), nil, nil, 0, 0, 'right-bottom');
		cancelButton:AddOnClickEventHandler(cancelButtonClick);
		this:AddComponent(cancelButton);

		defaultButton = Button(System:GetLocalizedString('Action.SetDefault'), nil, nil, saveChangesButton:GetText():len() + 1, 0, 'left-bottom');
		defaultButton:AddOnClickEventHandler(defaultButtonClick);
		this:AddComponent(defaultButton);
	end

	local function constructor(_localizationManager)
		localizationManager = _localizationManager;

		this:SetTitle(localizationManager:GetLocalizedString('ColorConfiguration.Title'));

		initializeComponents();

		colorConfiguration = System:GetColorConfiguration();

		local data = colorConfiguration:GetData();

		for key, _ in pairs(data) do
			colorListBox:AddItem(key);
		end		

		colorListBox:SetSelectedIndex(1);
	end

	constructor(_localizationManager);
end)
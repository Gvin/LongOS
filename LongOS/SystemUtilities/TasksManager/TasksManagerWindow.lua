local Window = Classes.Application.Window;
local Button = Classes.Components.Button;
local Label = Classes.Components.Label;
local VerticalScrollBar = Classes.Components.VerticalScrollBar;
local LocalizationManager = Classes.System.Localization.LocalizationManager;

TasksManagerWindow = Class(Window, function(this, _application)
	Window.init(this, _application, 'Gvin tasks manager', false);
	this:SetWidth(40);
	this:SetHeight(15);
	this:SetMinimalWidth(30);
	this:SetMinimalHeight(7);

	local selectedApplicationId;

	local tasksCountLabel;
	local vScrollBar;
	local killProcessButton;
	local setActiveButton;

	local localizationManager;

	local function drawProcesses(videoBuffer)
		local applications = System:GetApplicationsList();
		videoBuffer:SetTextColor(colors.black);
		videoBuffer:SetBackgroundColor(colors.white);

		local drawTo = #applications;
		if (drawTo > this:GetHeight() - 4 + vScrollBar:GetValue()) then
			drawTo = this:GetHeight() - 4 + vScrollBar:GetValue();
		end

		for i = vScrollBar:GetValue() + 1, drawTo do
			if (applications[i].Id == selectedApplicationId) then
				videoBuffer:SetTextColor(colors.lime);
			else
				videoBuffer:SetTextColor(colors.black);
			end
			videoBuffer:WriteAt(3, 1 + i - vScrollBar:GetValue(), i..') '..applications[i].Name..' : '..applications[i].WindowsCount);
		end
	end

	local function drawProcessesGrid(videoBuffer)
		videoBuffer:SetBackgroundColor(colors.white);
		for i = 2, this:GetHeight() - 3 do
			videoBuffer:SetCursorPos(1, i);
			for j = 2, this:GetWidth() - 2 do
				videoBuffer:Write(' ');
			end
		end
	end

	local function onWindowResize(_sender, _eventArgs)
		vScrollBar:SetHeight(this:GetHeight() - 4);
	end

	this.Draw = function(_, videoBuffer)
		tasksCountLabel:SetText(localizationManager:GetLocalizedString('Labels.ApplicationsCount')..System:GetApplicationsCount());
		drawProcessesGrid(videoBuffer);
		drawProcesses(videoBuffer);
	end

	this.Update = function(_)
		local applications = System:GetApplicationsList();
		vScrollBar:SetMaxValue(#applications - 1)
	end

	local getSelectedLine = function(cursorY)
		local applications = System:GetApplicationsList();
		return cursorY - this:GetY() - 1 + vScrollBar:GetValue();
	end

	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		local applications = System:GetApplicationsList();
		if (cursorY >= this:GetY() + 2 and cursorY <= this:GetY() + this:GetHeight() - 3 and cursorX < this:GetX() + this:GetWidth() - 4) then
			local selectedLine = getSelectedLine(cursorY);
			if (applications[selectedLine] ~= nil) then
				selectedApplicationId = applications[selectedLine].Id;
			end
		end
	end

	this.ProcessMouseScrollEvent = function(_, _direction, _cursorX, _cursorY)
		if (_direction < 0) then
			vScrollBar:ScrollUp();
		else
			vScrollBar:ScrollDown();
		end
	end

	local function setActiveButtonClick(sender, eventArgs)
		System:SetCurrentApplication(selectedApplicationId);
	end

	local function killProcessButtonClick(sender, eventArgs)
		System:RemoveApplication(selectedApplicationId);
	end

	local function initializeComponents()
		killProcessButton = Button(localizationManager:GetLocalizedString('Buttons.CloseApplication'), nil, nil, 0, 0, 'left-bottom');
		killProcessButton:AddOnClickEventHandler(killProcessButtonClick);
		this:AddComponent(killProcessButton);

		setActiveButton = Button(localizationManager:GetLocalizedString('Buttons.SetActive'), nil, nil, killProcessButton:GetText():len() + 1, 0, 'left-bottom');
		setActiveButton:AddOnClickEventHandler(setActiveButtonClick);
		this:AddComponent(setActiveButton);

		vScrollBar = VerticalScrollBar(0, 1, 11, nil, nil, 0, 1, 'right-top');
		this:AddComponent(vScrollBar);

		tasksCountLabel = Label(localizationManager:GetLocalizedString('Labels.ApplicationsCount')..System:GetApplicationsCount(), nil, nil, 0, 0, 'left-top');
		this:AddComponent(tasksCountLabel);
	end

	local function constructor()
		selectedApplicationId = '';
		this:AddOnResizeEventHandler(onWindowResize);

		localizationManager = LocalizationManager(fs.combine(this:GetApplication():GetWorkingDirectory(), 'Localizations'), fs.combine(this:GetApplication():GetWorkingDirectory(), 'Localizations/default.xml'));
		localizationManager:ReadLocalization(System:GetSystemLocale());

		this:SetTitle(localizationManager:GetLocalizedString('Title'));

		initializeComponents();
	end

	constructor();
end)
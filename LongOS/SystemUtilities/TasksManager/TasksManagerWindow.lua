local Window = Classes.Application.Window;
local Button = Classes.Components.Button;
local Label = Classes.Components.Label;
local VerticalScrollBar = Classes.Components.VerticalScrollBar;

TasksManagerWindow = Class(Window, function(this, _application)
	Window.init(this, _application, 'Gvin tasks manager', false);
	this:SetTitle('Gvin tasks manager');
	this:SetX(5);
	this:SetY(3);
	this:SetWidth(40);
	this:SetHeight(15);
	this:SetMinimalWidth(30);
	this:SetMinimalHeight(7);

	local scroll = 0;
	local selectedApplicationId = '';

	local tasksCountLabel = Label('Applications count: '..System:GetApplicationsCount(), nil, nil, 0, 0, 'left-top');
	this:AddComponent(tasksCountLabel);

	local vScrollBar = VerticalScrollBar(0, 1, 11, nil, nil, 0, 1, 'right-top');
	this:AddComponent(vScrollBar);

	local function killProcessButtonClick(sender, eventArgs)
		System:RemoveApplication(selectedApplicationId);
	end

	local killProcessButton = Button('Close application', nil, nil, 0, 0, 'left-bottom');
	killProcessButton:AddOnClickEventHandler(killProcessButtonClick);
	this:AddComponent(killProcessButton);

	local function setActiveButtonClick(sender, eventArgs)
		System:SetCurrentApplication(selectedApplicationId);
	end

	local setActiveButton = Button('Set active', nil, nil, 18, 0, 'left-bottom');
	setActiveButton:AddOnClickEventHandler(setActiveButtonClick);
	this:AddComponent(setActiveButton);

	local drawProcesses = function(videoBuffer)
		tasksCountLabel.Text = 'Applications count: '..System:GetApplicationsCount();

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

	local drawProcessesGrid = function(videoBuffer)
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

	this:AddOnResizeEventHandler(onWindowResize);

	this.Draw = function(_, videoBuffer)
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
end)
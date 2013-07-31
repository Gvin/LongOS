local function killProcessButtonClick(params)
	params[1]:CloseApplication();
end

local function setActiveButtonClick(params)
	params[1]:SetActive();
end

TasksManagerWindow = Class(Window, function(this, application)
	Window.init(this, application, 'Gvin tasks manager', false, false, 'Gvin tasks manager', 5, 3, 40, 15, nil, true, true);
	local scroll = 0;
	local selectedApplicationId = '';

	local tasksCountLabel = Label('Applications count: '..System:GetApplicationsCount(), nil, nil, 2, 1, 'left-top');
	this:AddComponent(tasksCountLabel);

	local vScrollBar = VerticalScrollBar(0, 1, 11, nil, nil, -2, 2, 'right-top');
	this:AddComponent(vScrollBar);

	local killProcessButton = Button('Close application', nil, nil, 2, -2, 'left-bottom');
	killProcessButton.OnClick = killProcessButtonClick;
	killProcessButton.OnClickParams = { this };
	this:AddComponent(killProcessButton);

	local setActiveButton = Button('Set active', nil, nil, -12, -2, 'right-bottom');
	setActiveButton.OnClick = setActiveButtonClick;
	setActiveButton.OnClickParams = { this };
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
			videoBuffer:WriteAt(this:GetX() + 3, this:GetY() + 1 + i - vScrollBar:GetValue(), i..') '..applications[i].Name..' : '..applications[i].WindowsCount);
		end
	end

	local drawProcessesGrid = function(videoBuffer)
		videoBuffer:SetBackgroundColor(colors.white);
		for i = 2, this:GetHeight() - 3 do
			videoBuffer:SetCursorPos(this:GetX() + 2, this:GetY() + i);
			for j = 2, this:GetWidth() - 3 do
				videoBuffer:Write(' ');
			end
		end
	end

	this.Draw = function(_, videoBuffer)
		vScrollBar.Height = this:GetHeight() - 4;
		drawProcessesGrid(videoBuffer);
		drawProcesses(videoBuffer);
	end

	this.Update = function(_)
		local applications = System:GetApplicationsList();
		vScrollBar:SetMaxValue(#applications - 1)
	end

	this.ScrollUp = function(_)
		if (scroll > 0) then
			scroll = scroll - 1;
		end
	end

	this.ScrollDown = function()
		local applications = System:GetApplicationsList();
		if (scroll < #applications - 1) then
			scroll = scroll + 1;
		end
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

	this.CloseApplication = function(_)
		System:DeleteApplication(selectedApplicationId);
	end

	this.SetActive = function(_)
		System:SetCurrentApplication(selectedApplicationId);
	end
end)
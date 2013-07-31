-- Window class. Contains all window data, draw and update functions.
-- For creating programs with windows, you should create child classes
-- from this class.
local function closeWindow(params)
	params[1]:Close();
end

local function maximizeWindow(params)
	params[1].Maximized = not params[1].Maximized;
end

Window = Class(function(this, application, x, y, width, height, allowMaximize, allowMove, backgroundColor, name, title, isUnique)

	this.GetClassName = function()
		return 'Window';
	end

	this._application = application;
	this.Name = name;
	this.IsUnique = isUnique;
	this.Id = 'none';
	this.Title = title;
	this.BackgroundColor = backgroundColor;

	local screenWidth, screenHeight = term.getSize();
	local colorConfiguration = System:GetColorConfiguration();
	local interfaceConfiguration = System:GetInterfaceConfiguration();

	this.X = x;
	this.Y = y;
	this.Width = width;
	this.Height = height;
	this.Visible = true;
	this.Maximized = false;
	this.Enabled = true;
	this.AllowMove = allowMove;
	this.IsModal = false;

	if (this.X + this.Width - 1 > screenWidth) then
		this.Width = screenWidth + 1 - this.X;
	end
	if (this.Y + this.Height - 1 > screenHeight - 1) then
		this.Height = screenHeight - this.Y;
	end

	local componentsManager = ComponentsManager();
	local menuesManager = MenuesManager();
	local realWidht = width;
	local realHeight = height;
	local isMoving = false;

	local titlePosition = this.X + 1;
	local closeButton = Button('X', colors.black, colors.white, -1, 0, 'right-top');
	local maximizeButton = Button('[]', colors.black, colors.white, -3, 0, 'right-top');
	if (interfaceConfiguration:GetOption('WindowButtonsPosition') == 'left') then
		closeButton = Button('X', colors.black, colors.white, 0, 0, 'left-top');
		maximizeButton = Button('[]', colors.black, colors.white, 1, 0, 'left-top');
		titlePosition = this.X + 2;
		if (allowMaximize) then
			titlePosition = this.X + 4;
		end
	end
	-- Adding standart buttons

	local closeButtonClick = function(sender, eventArgs)
		this:Close();
	end

	componentsManager:AddComponent(closeButton);
	closeButton:SetOnClick(EventHandler(closeButtonClick));

	if (allowMaximize) then
		local maximizeButtonClick = function(sender, eventArgs)
			this.Maximized = not this.Maximized;
		end

		componentsManager:AddComponent(maximizeButton);
		maximizeButton:SetOnClick(EventHandler(maximizeButtonClick));
	end

----------------------- Standard window functions -----------------------

	this.Close = function(_)
		this._application:DeleteWindow(this.Id);
	end

	this.Show = function(_)
		this._application:AddWindow(this);
	end

	this.Maximize = function(_)
		this.Maximized = true;
	end

	this.Minimize = function(_)
		this.Maximized = false;
	end

	local function updateSize()
		if (this.Width - 1 > screenWidth) then
			this.Width = screenWidth;
		end
		if (this.Height - 1 > screenHeight) then
			this.Height = screenHeight;
		end

		if (this.Maximized) then
			this.Width = screenWidth;
			this.Height = screenHeight - 1;
			this.X = 1;
			this.Y = System:GetTopLineIndex();
		else
			this.Width = realWidht;
			this.Height = realHeight;
		end
	end

	this.SetSize = function(_, width, height)
		realWidht = width;
		realHeight = height;
		updateSize();
	end

	this.Contains = function(_, x, y)
		return (x >= this.X and x <= this.X + this.Width - 1 and y >= this.Y and y <= this.Y + this.Height - 1) or menuesManager:Contains(x, y);
	end

----------------------- Components operations ---------------------------

	this.AddComponent = function(_, component)
		componentsManager:AddComponent(component);
	end

----------------------- Menues operations -------------------------------

	this.OpenCloseMenu = function(_, name)
		menuesManager:OpenCloseMenu(name);
	end

	this.GetMenu = function(_, name)
		return menuesManager:GetMenu(name);
	end

	this.AddMenu = function(_, name, menu)
		menuesManager:AddMenu(name, menu);
	end

	this.OpenMenu = function(_, name)
		menuesManager:OpenMenu(name);
	end

	this.CloseAllMenues = function(_)
		menuesManager:CloseAll();
	end

----------------------- Drawing -----------------------------------------

	local function drawTopLine(videoBuffer)
		local topLineColor = colorConfiguration:GetColor('TopLineActiveColor');
		if (this.Enabled) then
			videoBuffer:SetBackgroundColor(colorConfiguration:GetColor('TopLineActiveColor'));
			closeButton:SetBackgroundColor(colorConfiguration:GetColor('TopLineActiveColor'));
			if (maximizeButton ~= nil) then
				maximizeButton:SetBackgroundColor(colorConfiguration:GetColor('TopLineActiveColor'));
			end
		else
			topLineColor = colorConfiguration:GetColor('TopLineInactiveColor');
			videoBuffer:SetBackgroundColor(colorConfiguration:GetColor('TopLineInactiveColor'));
			closeButton:SetBackgroundColor(colorConfiguration:GetColor('TopLineInactiveColor'));
			if (maximizeButton ~= nil) then
				maximizeButton:SetBackgroundColor(colorConfiguration:GetColor('TopLineInactiveColor'));
			end
		end

		videoBuffer:DrawBlock(this.X, this.Y, this.Width, 1, topLineColor);

		titlePosition = this.X + 1;
		if (interfaceConfiguration:GetOption('WindowButtonsPosition') == 'left') then
			titlePosition = this.X + 2;
			if (allowMaximize) then
				titlePosition = this.X + 4;
			end
		end

		local titleToPrint = this.Title;
		if (string.len(titleToPrint) > this.Width - 4) then
			titleToPrint = string.sub(this.Title, 1, this.Width - 7);
			titleToPrint = titleToPrint..'...';
		end

		videoBuffer:SetTextColor(colorConfiguration:GetColor('TopLineTextColor'));
		videoBuffer:WriteAt(titlePosition, this.Y, titleToPrint);
	end

	local function drawCanvas(videoBuffer)
		videoBuffer:DrawBlock(this.X + 1, this.Y + 1, this.Width - 2, this.Height - 2, this.BackgroundColor, ' ');
	end

	local function drawFrame(videoBuffer)
		drawTopLine(videoBuffer);
		
		videoBuffer:SetBackgroundColor(this.BackgroundColor);
		videoBuffer:SetTextColor(colorConfiguration:GetColor('WindowBorderColor'));
		for i = 1, this.Height - 2 do
			videoBuffer:WriteAt(this.X, this.Y + i, '|');
			videoBuffer:WriteAt(this.X + this.Width - 1, this.Y + i, '|');
		end

		videoBuffer:SetCursorPos(this.X, this.Y + this.Height - 1);
		videoBuffer:Write('+');
		for i = 2, this.Width - 1 do
			videoBuffer:Write('-');
		end
		videoBuffer:Write('+');
	end

	local function drawComponents(videoBuffer)
		componentsManager:Draw(videoBuffer, this.X, this.Y, this.Width, this.Height);
	end

	local function drawMenues(videoBuffer)
		menuesManager:Draw(videoBuffer);
	end

	local function draw(videoBuffer)
		if (this.Visible) then
			drawFrame(videoBuffer);
			drawCanvas(videoBuffer);
			drawComponents(videoBuffer);
		end
	end

	local function drawBase(videoBuffer)
		this.BackgroundColor = colorConfiguration:GetColor('WindowColor');
		updateSize();
		draw(videoBuffer);
	end

	this.DrawBase = function(_, videoBuffer)
		drawBase(videoBuffer);
		this:Draw(videoBuffer);
		drawMenues(videoBuffer);
	end

	this.Draw = function(_, videoBuffer)	
	end

----------------------- Updating ----------------------------------------

	this.UpdateBase = function(_)
		this:Update();
	end

	this.Update = function(_)
	end

----------------------- Left click processing ---------------------------

	local function processLeftClickEvent(cursorX, cursorY)
		if (menuesManager:ProcessLeftClickEvent(cursorX, cursorY)) then
			return true;
		end
		if (componentsManager:ProcessLeftClickEvent(cursorX, cursorY)) then
			return true;
		end
		if (cursorY == this.Y and cursorX >= this.X and cursorX <= this.X + this.Width - 1) then
			isMoving = not isMoving;
			return true;
		end
	end

	this.ProcessLeftClickEventBase = function(_, cursorX, cursorY)
		if (this:Contains(cursorX, cursorY)) then
			if (processLeftClickEvent(cursorX, cursorY)) then
				return true;
			end
			this:ProcessLeftClickEvent(cursorX, cursorY);
		end
		return false;
	end

	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
	end

----------------------- Right click processing --------------------------

	this.ProcessRightClickEventBase = function(_, cursorX, cursorY)
		if (this:Contains(cursorX, cursorY)) then
			this:ProcessRightClickEvent(cursorX, cursorY);
		end
		return this:Contains(cursorX, cursorY);
	end

	this.ProcessRightClickEvent = function(_, cursorX, cursorY)
	end

----------------------- Double click processing -------------------------

	local function processDoubleClickEvent(cursorX, cursorY)
		return componentsManager:ProcessDoubleClickEvent(cursorX, cursorY);
	end

	this.ProcessDoubleClickEventBase = function(_, cursorX, cursorY)
		if (this:Contains(cursorX, cursorY)) then
			processDoubleClickEvent(cursorX, cursorY);
			this:ProcessDoubleClickEvent(cursorX, cursorY);
		end
	end

	this.ProcessDoubleClickEvent = function(_, cursorX, cursorY)
	end

----------------------- Keys processing ---------------------------------

	local function processUpArrowKey()
		if (this.Y > System:GetTopLineIndex()) then
			this.Y = this.Y - 1;
		end
	end

	local function processLeftArrowKey()
		if (this.X > 1) then
			this.X = this.X - 1;
		end
	end

	local function processDownArrowKey()
		if (this.Y < screenHeight - 2 + System:GetTopLineIndex()) then
			this.Y = this.Y + 1;
		end
	end

	local function processRightArrowKey()
		if (this.X < screenWidth) then
			this.X = this.X + 1;
		end
	end

	local function processKeyEvent(key)
		if (this.AllowMove and isMoving) then
			local keyName = keys.getName(key);
			if (keyName == 'up') then --------- Up arrow
				processUpArrowKey();
			elseif (keyName == 'down') then --- Down arrow
				processDownArrowKey();
			elseif (keyName == 'left') then --- Left arrow
				processLeftArrowKey();
			elseif (keyName == 'right') then -- Right arrow
				processRightArrowKey();
			end
		end
		componentsManager:ProcessKeyEvent(key);
	end

	this.ProcessKeyEventBase = function(_, key)
		processKeyEvent(key);
		this:ProcessKeyEvent(key);
	end

	this.ProcessKeyEvent = function(_, key)
	end

----------------------- Chars processing --------------------------------

	local function processCharEvent(char)
		componentsManager:ProcessCharEvent(char);
	end

	this.ProcessCharEventBase = function(_, char)
		if (processCharEvent(char)) then
			return;
		end
		this:ProcessCharEvent(char);
	end

	this.ProcessCharEvent = function(_, char)
	end

----------------------- Rednet processing -------------------------------

	this.ProcessRednetEventBase = function(_, id, message, distance)
		this:ProcessRednetEvent(id, message, distance);
	end

	this.ProcessRednetEvent = function(_, id, message, distance)
	end
end)
-- Window class. Contains all window data, draw and update functions.
-- For creating programs with windows, you should create child classes
-- from this class.
local function closeWindow(params)
	params[1]:Close();
end

local function maximizeWindow(params)
	params[1].Maximized = not params[1].Maximized;
end

Window = Class(function(this, _application, _name, _isUnique, _isModal, _title, _x, _y, _width, _height,  _backgroundColor, _allowMaximize, _allowMove)

	this.GetClassName = function()
		return 'Window';
	end

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local application;
	local name;
	local isUnique;
	local id;
	local title;
	local backgroundColor;
	local isModal;

	local x;
	local y;
	local width;
	local height;
	local visible;
	local maximized;
	local enabled;
	local allowMove;

	local miniWidth;
	local miniHeight;
	local miniX;
	local miniY;
	local isMoving;

	local screenWidth, screenHeight = term.getSize();

	local colorConfiguration;
	local interfaceConfiguration;
	local componentsManager;
	local menuesManager;

	local closeButton;
	local maximizeButton;

	------------------------------------------------------------------------------------------------------------------
	----- Properties -------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this.GetApplication()
		return application;
	end

	function this.GetName()
		return name;
	end

	function this.GetIsUnique()
		return isUnique;
	end

	function this.GetId()
		return id;
	end

	function this.SetId(_, _value)
		id = _value;
	end

	function this.GetTitle()
		return title;
	end

	function this.SetTitle(_, _value)
		title = _value;
	end

	function this.GetBackgroundColor()
		return backgroundColor;
	end

	function this.SetBackgroundColor(_, _value)
		backgroundColor = _value;
	end

	function this.GetIsModal()
		return isModal;
	end

	function this.GetX()
		return x;
	end

	function this.SetX(_, _value)
		x = _value;
		if (x < 1) then
			x = 1;
		end
		if (x > screenWidth) then
			x = screenWidth;
		end
		miniX = x;
	end

	function this.GetY()
		return y;
	end

	function this.SetY(_, _value)
		y = _value;
		local topLineIndex = System:GetTopLineIndex();
		if (y < topLineIndex) then
			y = topLineIndex;
		end
		if (y > screenHeight - 2 + topLineIndex) then
			y = screenHeight - 2 + topLineIndex;
		end
		miniY = y;
	end

	function this.GetWidth()
		return width;
	end

	function this.SetWidth(_, _value)
		width = _value;
		if (x + width - 1 > screenWidth) then
			width = screenWidth + 1 - x;
		end
		if (width < 4) then
			width = 4;
		end
	end

	function this.GetHeight()
		return height;
	end

	function this.SetHeight(_, _value)
		height = _value;
		if (y + height - 1 > screenHeight - 1) then
			height = screenHeight - y;
		end
		if (height < 3) then
			height = 3;
		end
	end

	function this.GetVisible()
		return visible;
	end

	function this.SetVisible(_, _value)
		visible = _value;
	end

	function this.GetMaximized()
		return maximized;
	end

	function this.SetMaximized(_, _value)
		maximized = _value;
	end

	function this.GetEnabled()
		return enabled;
	end

	function this.SetEnabled(_, _value)
		enabled = _value;
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ---------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------
	
	function this.Close()
		application:DeleteWindow(id);
	end

	function this.Show()
		application:AddWindow(this);
	end

	function this.Maximize()
		maximized = true;
	end

	function Minimize()
		maximized = false;
	end

	function this.Contains(_, _x, _y)
		return (_x >= x and _x <= x + width - 1 and _y >= y and _y <= y + height - 1) or menuesManager:Contains(_x, _y);
	end

	function this.AddComponent(_, _component)
		componentsManager:AddComponent(_component);
	end

	function this.OpenCloseMenu(_, _menuName)
		menuesManager:OpenCloseMenu(_menuName);
	end

	function this.GetMenu(_, _menuName)
		return menuesManager:GetMenu(_menuName);
	end

	function this.AddMenu(_, _menuName, _menu)
		menuesManager:AddMenu(_menuName, _menu);
	end

	function this.OpenMenu(_, _menuName)
		menuesManager:OpenMenu(_menuName);
	end

	function this.CloseAllMenues()
		menuesManager:CloseAll();
	end

	-- Drawing

	local function drawTopLine(_videoBuffer)
		local topLineColor = colorConfiguration:GetColor('TopLineActiveColor');
		if (enabled) then
			_videoBuffer:SetBackgroundColor(colorConfiguration:GetColor('TopLineActiveColor'));
			closeButton:SetBackgroundColor(colorConfiguration:GetColor('TopLineActiveColor'));
			if (maximizeButton ~= nil) then
				maximizeButton:SetBackgroundColor(colorConfiguration:GetColor('TopLineActiveColor'));
			end
		else
			topLineColor = colorConfiguration:GetColor('TopLineInactiveColor');
			_videoBuffer:SetBackgroundColor(colorConfiguration:GetColor('TopLineInactiveColor'));
			closeButton:SetBackgroundColor(colorConfiguration:GetColor('TopLineInactiveColor'));
			if (maximizeButton ~= nil) then
				maximizeButton:SetBackgroundColor(colorConfiguration:GetColor('TopLineInactiveColor'));
			end
		end

		_videoBuffer:DrawBlock(x, y, width, 1, topLineColor);

		local titlePosition = x + 1;
		if (interfaceConfiguration:GetOption('WindowButtonsPosition') == 'left') then
			titlePosition = x + 2;
			if (allowMaximize) then
				titlePosition = x + 4;
			end
		end

		local titleToPrint = title;
		if (string.len(titleToPrint) > width - 4) then
			titleToPrint = string.sub(title, 1, width - 7);
			titleToPrint = titleToPrint..'...';
		end

		_videoBuffer:SetTextColor(colorConfiguration:GetColor('TopLineTextColor'));
		_videoBuffer:WriteAt(titlePosition, y, titleToPrint);
	end

	local function drawCanvas(_videoBuffer)
		_videoBuffer:DrawBlock(x + 1, y + 1, width - 2, height - 2, backgroundColor, ' ');
	end

	local function drawFrame(_videoBuffer)
		drawTopLine(_videoBuffer);
		
		_videoBuffer:SetBackgroundColor(backgroundColor);
		_videoBuffer:SetTextColor(colorConfiguration:GetColor('WindowBorderColor'));
		for i = 1, height - 2 do
			_videoBuffer:WriteAt(x, y + i, '|');
			_videoBuffer:WriteAt(x + width - 1, y + i, '|');
		end

		_videoBuffer:SetCursorPos(x, y + height - 1);
		_videoBuffer:Write('+');
		for i = 2, width - 1 do
			_videoBuffer:Write('-');
		end
		_videoBuffer:Write('+');
	end

	local function drawComponents(_videoBuffer)
		componentsManager:Draw(_videoBuffer, x, y, width, height);
	end

	local function drawMenues(_videoBuffer)
		menuesManager:Draw(_videoBuffer);
	end

	local function draw(_videoBuffer)
		drawFrame(_videoBuffer);
		drawCanvas(_videoBuffer);
		drawComponents(_videoBuffer);
	end

	local function updateSize()
		if (width - 1 > screenWidth) then
			width = screenWidth;
		end
		if (height - 1 > screenHeight) then
			height = screenHeight;
		end

		if (maximized) then
			width = screenWidth;
			height = screenHeight - 1;
			x = 1;
			y = System:GetTopLineIndex();
		else
			width = miniWidth;
			height = miniHeight;
			x = miniX;
			y = miniY;
		end
	end

	local function drawBase(_videoBuffer)
		backgroundColor = colorConfiguration:GetColor('WindowColor');
		updateSize();
		draw(_videoBuffer);
	end

	function this.DrawBase(_, _videoBuffer)
		if (visible) then
			drawBase(_videoBuffer);
			this:Draw(_videoBuffer);
			drawMenues(_videoBuffer);
		end
	end

	function this.Draw(_, _videoBuffer)	
	end

	-- Updating

	function this.UpdateBase()
		this:Update();
	end

	function this.Update()
	end

	-- Events processing

	local function processLeftClickEvent(_cursorX, _cursorY)
		if (menuesManager:ProcessLeftClickEvent(_cursorX, _cursorY)) then
			return true;
		end
		if (componentsManager:ProcessLeftClickEvent(_cursorX, _cursorY)) then
			return true;
		end
		if (_cursorY == y and _cursorX >= x and _cursorX <= x + width - 1) then
			isMoving = not isMoving;
			return true;
		end
	end

	function this.ProcessLeftClickEventBase(_, _cursorX, _cursorY)
		if (this:Contains(_cursorX, _cursorY)) then
			if (processLeftClickEvent(_cursorX, _cursorY)) then
				return true;
			end
			this:ProcessLeftClickEvent(_cursorX, _cursorY);
		end
		return false;
	end

	function this.ProcessLeftClickEvent(_, _cursorX, _cursorY)
	end

	function this.ProcessRightClickEventBase(_, _cursorX, _cursorY)
		if (this:Contains(_cursorX, _cursorY)) then
			this:ProcessRightClickEvent(_cursorX, _cursorY);
		end
		return this:Contains(_cursorX, _cursorY);
	end

	function this.ProcessRightClickEvent(_, _cursorX, _cursorY)
	end

	local function processDoubleClickEvent(_cursorX, _cursorY)
		return componentsManager:ProcessDoubleClickEvent(_cursorX, _cursorY);
	end

	function this.ProcessDoubleClickEventBase(_, _cursorX, _cursorY)
		if (this:Contains(_cursorX, _cursorY)) then
			processDoubleClickEvent(_cursorX, _cursorY);
			this:ProcessDoubleClickEvent(_cursorX, _cursorY);
		end
	end

	function this.ProcessDoubleClickEvent(_, _cursorX, _cursorY)
	end

----------------------- Keys processing ---------------------------------

	local function processUpArrowKey()
		this:SetY(y - 1);
	end

	local function processLeftArrowKey()
		this:SetX(x - 1);
	end

	local function processDownArrowKey()
		this:SetY(y + 1);
	end

	local function processRightArrowKey()
		this:SetX(x + 1);
	end

	local function processKeyEvent(_key)
		if (allowMove and isMoving) then
			local keyName = keys.getName(_key);
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
		componentsManager:ProcessKeyEvent(_key);
	end

	function this.ProcessKeyEventBase(_, _key)
		processKeyEvent(_key);
		this:ProcessKeyEvent(_key);
	end

	function this.ProcessKeyEvent(_, _key)
	end

	local function processCharEvent(_symbol)
		componentsManager:ProcessCharEvent(_symbol);
	end

	function this.ProcessCharEventBase(_, _symbol)
		if (processCharEvent(_symbol)) then
			return;
		end
		this:ProcessCharEvent(_symbol);
	end

	function this.ProcessCharEvent(_, _symbol)
	end

	function this.ProcessRednetEventBase(_, _id, _message, _distance)
		this:ProcessRednetEvent(_id, _message, _distance);
	end

	function this.ProcessRednetEvent(_, _id, _message, _distance)
	end

	local function closeButtonClick(sender, eventArgs)
		this:Close();
	end

	local function maximizeButtonClick(sender, eventArgs)
		maximized = not maximized;
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor(_application, _name, _isUnique, _isModal, _title, _x, _y, _width, _height,  _backgroundColor, _allowMaximize, _allowMove)
		if (type(_application) ~= 'table' or _application:GetClassName() ~= 'Application') then
			error('Window.Constructor [application]: Application expected, got '..type(_application)..'.');
		end
		if (type(_name) ~= 'string') then
			error('Window.Constructor [name]: String expected, got '..type(_name)..'.');
		end
		if (type(_isUnique) ~= 'boolean') then
			error('Window.Constructor [isUnique]: Boolean expected, got '..type(_isUnique)..'.');
		end
		if (type(_isModal) ~= 'boolean') then
			error('Window.Constructor [isModal]: Boolean expected, got '..type(_isModal)..'.');
		end
		if (type(_title) ~= 'string') then
			error('Window.Constructor [title]: String expected, got '..type(_title)..'.');
		end
		if (type(_x) ~= 'number') then
			error('Window.Constructor [x]: Number expected, got '..type(_x)..'.');
		end
		if (type(_y) ~= 'number') then
			error('Window.Constructor [y]: Number expected, got '..type(_y)..'.');
		end
		if (type(_width) ~= 'number') then
			error('Window.Constructor [width]: Number expected, got '..type(_width)..'.');
		end
		if (type(_height) ~= 'number') then
			error('Window.Constructor [height]: Number expected, got '..type(_height)..'.');
		end
		if (_backgroundColor ~= nil and type(_backgroundColor) ~= 'number') then
			error('Window.Constructor [backgroundColor]: Number or nil expected, got '..type(_backgroundColor)..'.');
		end
		if (type(_allowMaximize) ~= 'boolean') then
			error('Window.Constructor [allowMaximize]: Boolean expected, got '..type(_allowMaximize)..'.');
		end
		if (type(_allowMove) ~= 'boolean') then
			error('Window.Constructor [allowMove]: Boolean expected, got '..type(_allowMove)..'.');
		end

		application = _application;
		name = _name;
		isUnique = _isUnique;
		title = _title;
		this:SetX(_x);
		this:SetY(_y);
		this:SetWidth(_width);
		this:SetHeight(_height);
		backgroundColor = _backgroundColor;
		allowMaximize = _allowMaximize;
		allowMove = _allowMove;
		isModal = _isModal;

		maximized = false;
		miniX = x;
		miniY = y;
		miniWidth = width;
		miniHeight = height;
		isMoving = false;
		visible = true;

		colorConfiguration = System:GetColorConfiguration();
		interfaceConfiguration = System:GetInterfaceConfiguration();
		componentsManager = ComponentsManager();
		menuesManager = MenuesManager();

		-- Adding standard buttons

		closeButton = Button('X', colors.black, colors.white, -1, 0, 'right-top');
		componentsManager:AddComponent(closeButton);
		closeButton:SetOnClick(EventHandler(closeButtonClick));

		if (allowMaximize) then
			maximizeButton = Button('[]', colors.black, colors.white, -3, 0, 'right-top');
			componentsManager:AddComponent(maximizeButton);
			maximizeButton:SetOnClick(EventHandler(maximizeButtonClick));
		end
	end

	constructor(_application, _name, _isUnique, _isModal, _title, _x, _y, _width, _height, _backgroundColor, _allowMaximize, _allowMove);
end)
-- Window class. Contains all window data, draw and update functions.
-- For creating programs with windows, you should create child classes
-- from this class.
Window = Class(function(this, _application, _name, _isUnique)

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
	local minimalWidth;
	local minimalHeight;
	local visible;
	local maximized;
	local enabled;
	local allowMove;
	local allowResize;
	local allowMaximize;

	local miniWidth;
	local miniHeight;
	local miniX;
	local miniY;

	local oldMouseX;
	local oldMouseY;
	local isMoving;
	local isResizing;

	local screenWidth, screenHeight = term.getSize();

	local colorConfiguration;
	local interfaceConfiguration;
	local componentsManager;
	local menuesManager;

	local closeButton;
	local maximizeButton;

	local onClose;
	local onShow;
	local onMove;
	local onResize;

	local canvas;

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
		if (type(_value) ~= 'string') then
			error('Window.SetId [value]: String expected, got '..type(_isUnique)..'.');
		end
		id = _value;
	end

	function this.GetTitle()
		return title;
	end

	function this.SetTitle(_, _value)
		if (type(_value) ~= 'string') then
			error('Window.SetTitle [value]: String expected, got '..type(_isUnique)..'.');
		end
		title = _value;
	end

	function this.GetBackgroundColor()
		return backgroundColor;
	end

	function this.SetBackgroundColor(_, _value)
		if (_value ~= nil or type(_value) ~= 'number') then
			error('Window.SetBackgroundColor [value]: Number or nil expected, got '..type(_isUnique)..'.');
		end
		backgroundColor = _value;
	end

	function this.GetIsModal()
		return isModal;
	end

	function this.SetIsModal(_, _value)
		if (type(_value) ~= 'boolean') then
			error('Window.SetIsModal [value]: Boolean expected, got '..type(_isUnique)..'.');
		end
		isModal = _value;
	end

	function this.GetAllowMove()
		return allowMove;
	end

	function this.SetAllowMove(_, _value)
		if (type(_value) ~= 'boolean') then
			error('Window.SetAllowMove [value]: Boolean expected, got '..type(_isUnique)..'.');
		end
		allowMove = _value;
	end

	function this.GetAllowResize()
		return allowResize;
	end

	function this.SetAllowResize(_, _value)
		if (type(_value) ~= 'boolean') then
			error('Window.SetAllowResize [value]: Boolean expected, got '..type(_isUnique)..'.');
		end
		allowResize = _value;
	end

	function this.GetMinimalWidth()
		return minimalWidth;
	end

	function this.SetMinimalWidth(_, _value)
		if (type(_value) ~= 'number') then
			error('Window.SetMinimalWidth [value]: Number expected, got '..type(_isUnique)..'.');
		end
		minimalWidth = _value;
		if (minimalWidth < 7) then
			minimalWidth = 7;
		end
	end

	function this.GetMinimalHeight()
		return minimalHeight;
	end

	function this.SetMinimalHeight(_, _value)
		if (type(_value) ~= 'number') then
			error('Window.SetMinimalHeight [value]: Number expected, got '..type(_isUnique)..'.');
		end
		minimalHeight = _value;
		if (minimalHeight < 3) then
			minimalHeight = 3;
		end
	end

	function this.GetAllowMaximize()
		return allowMaximize;
	end

	function this.SetAllowMaximize(_, _value)
		if (type(_value) ~= 'boolean') then
			error('Window.SetAllowMaximize [value]: Boolean expected, got '..type(_isUnique)..'.');
		end
		allowMaximize = _value;
		maximizeButton:SetVisible(allowMaximize);
	end

	function this.GetX()
		return x;
	end

	local function raiseMoveEvent(_oldValue, _newValue, _value)
		local eventArgs = {};
		eventArgs.Old = _oldValue;
		eventArgs.New = _newValue;
		eventArgs.Value = _value;
		onMove:Invoke(this, eventArgs);
	end

	function this.SetX(_, _value)
		if (type(_value) ~= 'number') then
			error('Window.SetX [value]: Number expected, got '..type(_isUnique)..'.');
		end
		local old = x;
		x = _value;
		if (x < 1) then
			x = 1;
		end
		if (x > screenWidth) then
			x = screenWidth;
		end
		miniX = x;
		raiseMoveEvent(old, x, 'X');
	end

	function this.GetY()
		return y;
	end

	function this.SetY(_, _value)
		if (type(_value) ~= 'number') then
			error('Window.SetY [value]: Number expected, got '..type(_isUnique)..'.');
		end
		local old = y;
		y = _value;
		local topLineIndex = System:GetTopLineIndex();
		if (y < topLineIndex) then
			y = topLineIndex;
		end
		if (y > screenHeight - 2 + topLineIndex) then
			y = screenHeight - 2 + topLineIndex;
		end
		miniY = y;
		raiseMoveEvent(old, y, 'Y');
	end

	function this.GetWidth()
		return width;
	end

	local function raiseResizeEvent(_oldValue, _newValue, _value)
		local eventArgs = {};
		eventArgs.Old = _oldValue;
		eventArgs.New = _newValue;
		eventArgs.Value = _value;
		onResize:Invoke(this, eventArgs);
	end

	function this.SetWidth(_, _value)
		if (type(_value) ~= 'number') then
			error('Window.SetWidth [value]: Number expected, got '..type(_isUnique)..'.');
		end
		local old = width;
		width = _value;
		if (x + width - 1 > screenWidth) then
			width = screenWidth + 1 - x;
		end
		if (width < minimalWidth) then
			width = minimalWidth;
		end
		miniWidth = width;
		raiseResizeEvent(old, width, 'width');
	end

	function this.GetHeight()
		return height;
	end

	function this.SetHeight(_, _value)
		if (type(_value) ~= 'number') then
			error('Window.SetHeight [value]: Number expected, got '..type(_isUnique)..'.');
		end
		local old = height;
		height = _value;
		if (y + height - 1 > screenHeight - 1) then
			height = screenHeight - y + 1;
		end
		if (height < minimalHeight) then
			height = minimalHeight;
		end
		miniHeight = height;
		raiseResizeEvent(old, height, 'height');
	end

	function this.GetVisible()
		return visible;
	end

	function this.SetVisible(_, _value)
		if (type(_value) ~= 'boolean') then
			error('Window.SetVisible [value]: Boolean expected, got '..type(_isUnique)..'.');
		end
		visible = _value;
	end

	function this.GetMaximized()
		return maximized;
	end

	function this.SetMaximized(_, _value)
		if (type(_value) ~= 'boolean') then
			error('Window.SetMaximized [value]: Boolean expected, got '..type(_isUnique)..'.');
		end
		if (allowMaximize) then
			local changed = (_value ~= maximized);

			local oldHeight = height;
			local oldWidth = width;

			maximized = _value;

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

			if (changed) then
				raiseResizeEvent(oldWidth, width, 'width');
				raiseResizeEvent(oldHeight, height, 'height');
			end
		end
	end

	function this.GetEnabled()
		return enabled;
	end

	function this.SetEnabled(_, _value)
		if (type(_value) ~= 'boolean') then
			error('Window.SetEnabled [value]: Boolean expected, got '..type(_isUnique)..'.');
		end
		enabled = _value;
	end

	function this.SetOnClose(_, _value)
		onClose:AddHandler(_value);
	end

	function this.SetOnShow(_, _value)
		onShow:AddHandler(_value);
	end

	function this.SetOnMove(_, _value)
		onMove:AddHandler(_value);
	end

	function this.SetOnResize(_, _value)
		onResize:AddHandler(_value);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ---------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------
	
	function this.Close()
		application:DeleteWindow(id);

		onClose:Invoke(this, {});
	end

	function this.Show()
		application:AddWindow(this);

		onShow:Invoke(this, {});
	end

	function this.Maximize()
		this:SetMaximized(true);
	end

	function this.Minimize()
		this:SetMaximized(false);
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

	local function isOnTopLine(_x, _y)
		return (_y == y and _x >= x and _x <= x + width - 1);
	end

	local function isOnRightBottomCorner(_x, _y)
		return (_y == y + height - 1 and _x == x + width - 1);
	end

	local function drawTopLine(_videoBuffer)
		local topLineColor = colorConfiguration:GetColor('TopLineActiveColor');
		if (enabled) then
			_videoBuffer:SetBackgroundColor(colorConfiguration:GetColor('TopLineActiveColor'));
			closeButton:SetBackgroundColor(colorConfiguration:GetColor('TopLineActiveColor'));
			maximizeButton:SetBackgroundColor(colorConfiguration:GetColor('TopLineActiveColor'));
		else
			topLineColor = colorConfiguration:GetColor('TopLineInactiveColor');
			_videoBuffer:SetBackgroundColor(colorConfiguration:GetColor('TopLineInactiveColor'));
			closeButton:SetBackgroundColor(colorConfiguration:GetColor('TopLineInactiveColor'));
			maximizeButton:SetBackgroundColor(colorConfiguration:GetColor('TopLineInactiveColor'));
		end

		_videoBuffer:DrawBlock(x, y, width, 1, topLineColor);

		local titlePosition = x + 1;
		if (interfaceConfiguration:GetOption('WindowButtonsPosition') == 'left') then
			closeButton:SetAnchor('left-top');
			closeButton.dX = 0;
			maximizeButton:SetAnchor('left-top');
			maximizeButton.dX = 1;

			titlePosition = x + 2;
			if (allowMaximize) then
				titlePosition = x + 4;
			end
		else
			closeButton:SetAnchor('right-top');
			closeButton.dX = -1;
			maximizeButton:SetAnchor('right-top');
			maximizeButton.dX = -3;
		end

		local titleToPrint = title;
		if (string.len(titleToPrint) > width - 4) then
			titleToPrint = string.sub(title, 1, width - 7);
			titleToPrint = titleToPrint..'...';
		end

		_videoBuffer:SetTextColor(colorConfiguration:GetColor('TopLineTextColor'));
		_videoBuffer:WriteAt(titlePosition, y, titleToPrint);

		closeButton:Draw(_videoBuffer, x, y, width, height);
		maximizeButton:Draw(_videoBuffer, x, y, width, height);
	end

	local function drawBlock(_videoBuffer)
		canvas:DrawBlock(1, 1, width - 2, height - 2, backgroundColor, ' ');
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
		if (allowResize) then
			_videoBuffer:Write('#');
		else
			_videoBuffer:Write('+');
		end
	end

	local function drawComponents(_videoBuffer)
		componentsManager:Draw(canvas, 1, 1, canvas:GetWidth(), canvas:GetHeight());
	end

	local function drawMenues(_videoBuffer)
		menuesManager:Draw(_videoBuffer);
	end

	local function draw(_videoBuffer)
		drawFrame(_videoBuffer);
		drawBlock(_videoBuffer);
		drawComponents(_videoBuffer);
	end

	local function updateSize()
		if (width - 1 > screenWidth) then
			width = screenWidth;
		end
		if (height - 1 > screenHeight) then
			height = screenHeight;
		end
	end

	local function drawBase(_videoBuffer)
		backgroundColor = colorConfiguration:GetColor('WindowColor');
		updateSize();
		draw(_videoBuffer);
	end

	function this.DrawBase(_, _videoBuffer)
		if (visible) then
			canvas:SetWidth(width - 2);
			canvas:SetHeight(height - 2);
			drawBase(_videoBuffer);
			this:Draw(canvas);
			canvas:Draw(_videoBuffer, x, y, width, height);
			drawMenues(_videoBuffer);
		end
	end

	function this.Draw(_, _canvas)	
	end

	-- Updating

	function this.UpdateBase()
		this:Update();
	end

	function this.Update()
	end

	-- Events processing

	function this.ResetDragging()
		isMoving = false;
		isResizing = false;
	end

	local function processLeftClickEvent(_cursorX, _cursorY)
		if (menuesManager:ProcessLeftClickEvent(_cursorX, _cursorY)) then
			return true;
		end
		if (closeButton:ProcessLeftClickEvent(_cursorX, _cursorY)) then
			return true;
		end
		if (maximizeButton:ProcessLeftClickEvent(_cursorX, _cursorY)) then
			return true;
		end
		if (componentsManager:ProcessLeftClickEvent(_cursorX, _cursorY)) then
			return true;
		end
		if (isOnTopLine(_cursorX, _cursorY)) then
			oldMouseX = _cursorX;
			oldMouseY = _cursorY;
			isMoving = true;
			return true;
		end
		if (isOnRightBottomCorner(_cursorX, _cursorY)) then
			oldMouseX = _cursorX;
			oldMouseY = _cursorY;
			isResizing = true;
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
		if (closeButton:ProcessDoubleClickEvent(_cursorX, _cursorY)) then
			return true;
		end
		if (maximizeButton:ProcessDoubleClickEvent(_cursorX, _cursorY)) then
			return true;
		end
		if (isOnTopLine(_cursorX, _cursorY)) then
			this:SetMaximized(not maximized);
			return true;
		end
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

	function this.ProcessLeftMouseDragEventBase(_, _newCursorX, _newCursorY)
		if (isMoving and allowMove) then
			if (maximized) then
				this:Minimize();
			end
			local dX = _newCursorX - oldMouseX;
			local dY = _newCursorY - oldMouseY;
			oldMouseX = _newCursorX;
			oldMouseY = _newCursorY;
			this:SetX(x + dX);
			this:SetY(y + dY);
		elseif (isResizing and allowResize) then
			local dX = _newCursorX - oldMouseX;
			local dY = _newCursorY - oldMouseY;
			oldMouseX = _newCursorX;
			oldMouseY = _newCursorY;
			this:SetWidth(width + dX);
			this:SetHeight(height + dY);
		else
			this:ProcessLeftMouseDragEvent(_newCursorX, _newCursorY);
		end
	end

	function this.ProcessLeftMouseDragEvent(_, _newCursorX, _newCursorY)
	end

	function this.ProcessRightMouseDragEventBase(_, _newCursorX, _newCursorY)
		this:ProcessRightMouseDragEvent(_newCursorX, _newCursorY);
	end

	function this.ProcessRightMouseDragEvent(_, _newCursorX, _newCursorY)
	end

	function this.ProcessMouseScrollEventBase(_, _direction, _cursorX, _cursorY)
		if (this:Contains(_cursorX, _cursorY)) then
			if (not componentsManager:ProcessMouseScrollEvent(_direction, _cursorX, _cursorY)) then
				this:ProcessMouseScrollEvent(_direction, _cursorX, _cursorY);
			end
		end
	end

	function this.ProcessMouseScrollEvent(_, _direction, _cursorX, _cursorY)
	end

----------------------- Keys processing ---------------------------------

	local function processKeyEvent(_key)
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
		this:SetMaximized(not maximized);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor(_application, _name, _isUnique)
		if (type(_application) ~= 'table' or _application:GetClassName() ~= 'Application') then
			error('Window.Constructor [application]: Application expected, got '..type(_application)..'.');
		end
		if (type(_name) ~= 'string') then
			error('Window.Constructor [name]: String expected, got '..type(_name)..'.');
		end
		if (type(_isUnique) ~= 'boolean') then
			error('Window.Constructor [isUnique]: Boolean expected, got '..type(_isUnique)..'.');
		end

		application = _application;
		name = _name;
		isUnique = _isUnique;

		-- default values
		title = 'Window';
		x = 2;
		y = 2;
		width = 20;
		height = 10;
		minimalWidth = 7;
		minimalHeight = 3;
		backgroundColor = nil;
		allowMaximize = true;
		allowMove = true;
		allowResize = true;
		isModal = false;

		maximized = false;
		miniX = x;
		miniY = y;
		miniWidth = width;
		miniHeight = height;
		visible = true;
		isMoving = false;

		onShow = EventHandler();
		onClose = EventHandler();
		onMove = EventHandler();
		onResize = EventHandler();

		colorConfiguration = System:GetColorConfiguration();
		interfaceConfiguration = System:GetInterfaceConfiguration();
		componentsManager = ComponentsManager();
		menuesManager = MenuesManager();
		canvas = Canvas(1, 1, width - 2, height - 2, 'left-top');

		-- creating components
		closeButton = Button('X', colors.black, colors.white, -1, 0, 'right-top');
		closeButton:SetOnClick(closeButtonClick);

		maximizeButton = Button('[]', colors.black, colors.white, -3, 0, 'right-top');
		maximizeButton:SetOnClick(maximizeButtonClick);
	end

	constructor(_application, _name, _isUnique);
end)
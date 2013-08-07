-- Window class. Contains all window data, draw and update functions.
-- For creating programs with windows, you should create child classes
-- from this class.
Window = Class(function(this, _application, _name, _isUnique, _isModal, _title, _x, _y, _width, _height, _minimalWidth, _minimalHeight,  _backgroundColor, _allowMaximize, _allowMove)

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
	local allowMaximize;

	local miniWidth;
	local miniHeight;
	local miniX;
	local miniY;

	local oldMouseX;
	local oldMouseY;
	local isMoving;

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

	local function move(_oldValue, _newValue, _value)
		if (onMove ~= nil) then
			local eventArgs = {};
			eventArgs.Old = _oldValue;
			eventArgs.New = _newValue;
			eventArgs.Value = _value;
			onMove:Invoke(this, eventArgs);
		end
	end

	function this.SetX(_, _value)
		local old = x;
		x = _value;
		if (x < 1) then
			x = 1;
		end
		if (x > screenWidth) then
			x = screenWidth;
		end
		miniX = x;
		move(old, x, 'X');
	end

	function this.GetY()
		return y;
	end

	function this.SetY(_, _value)
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
		move(old, y, 'Y');
	end

	function this.GetWidth()
		return width;
	end

	local function resize(_oldValue, _newValue, _value)
		if (onResize ~= nil) then
			local eventArgs = {};
			eventArgs.Old = _oldValue;
			eventArgs.New = _newValue;
			eventArgs.Value = _value;
			onResize:Invoke(this, eventArgs);
		end
	end

	function this.SetWidth(_, _value)
		local old = width;
		width = _value;
		if (x + width - 1 > screenWidth) then
			width = screenWidth + 1 - x;
		end
		if (width < minimalWidth) then
			width = minimalWidth;
		end
		resize(old, width, 'width');
	end

	function this.GetHeight()
		return height;
	end

	function this.SetHeight(_, _value)
		local old = height;
		height = _value;
		if (y + height - 1 > screenHeight - 1) then
			height = screenHeight - y + 1;
		end
		if (height < minimalHeight) then
			height = minimalHeight;
		end
		resize(old, height, 'height');
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
				resize(oldWidth, width, 'width');
				resize(oldHeight, height, 'height');
			end
		end
	end

	function this.GetEnabled()
		return enabled;
	end

	function this.SetEnabled(_, _value)
		enabled = _value;
	end

	function this.SetOnClose(_, _value)
		onClose = _value;
	end

	function this.SetOnShow(_, _value)
		onShow = _value;
	end

	function this.SetOnMove(_, _value)
		onMove = _value;
	end

	function this.SetOnResize(_, _value)
		onResize = _value;
	end

	------------------------------------------------------------------------------------------------------------------
	----- Methods ---------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------
	
	function this.Close()
		application:DeleteWindow(id);

		if (onClose ~= nil) then
			onClose:Invoke(this, {});
		end
	end

	function this.Show()
		application:AddWindow(this);

		if (onShow ~= nil) then
			onShow:Invoke(this, {});
		end
	end

	function this.Maximize()
		this:SetMaximized(true);
	end

	function Minimize()
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

		closeButton:Draw(_videoBuffer, x, y, width, height);
		if (maximizeButton ~= nil) then
			maximizeButton:Draw(_videoBuffer, x, y, width, height);
		end
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
		_videoBuffer:Write('+');
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

	function this.ResetMoving()
		isMoving = false;
	end

	local function processLeftClickEvent(_cursorX, _cursorY)
		if (menuesManager:ProcessLeftClickEvent(_cursorX, _cursorY)) then
			return true;
		end
		if (closeButton:ProcessLeftClickEvent(_cursorX, _cursorY)) then
			return true;
		end
		if (maximizeButton ~= nil and maximizeButton:ProcessLeftClickEvent(_cursorX, _cursorY)) then
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
		if (maximizeButton ~= nil and maximizeButton:ProcessDoubleClickEvent(_cursorX, _cursorY)) then
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
			local dX = _newCursorX - oldMouseX;
			local dY = _newCursorY - oldMouseY;
			oldMouseX = _newCursorX;
			oldMouseY = _newCursorY;
			this:SetX(x + dX);
			this:SetY(y + dY);
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
		if (type(_minimalWidth) ~= 'number') then
			error('Window.Constructor [minimalWidth]: Number expected, got '..type(_minimalWidth)..'.');
		end
		if (type(_minimalHeight) ~= 'number') then
			error('Window.Constructor [minimalHeight]: Number expected, got '..type(_minimalHeight)..'.');
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

		if (_minimalWidth > 7) then
			minimalWidth = _minimalWidth;
		else
			minimalWidth = 7;
		end
		if (_minimalHeight > 3) then
			minimalHeight = _minimalHeight;
		else
			minimalHeight = 3;
		end

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
		visible = true;
		isMoving = false;

		colorConfiguration = System:GetColorConfiguration();
		interfaceConfiguration = System:GetInterfaceConfiguration();
		componentsManager = ComponentsManager();
		menuesManager = MenuesManager();
		canvas = Canvas(1, 1, width - 2, height - 2, 'left-top');

		-- Adding standard buttons

		closeButton = Button('X', colors.black, colors.white, -1, 0, 'right-top');
		closeButton:SetOnClick(EventHandler(closeButtonClick));

		if (allowMaximize) then
			maximizeButton = Button('[]', colors.black, colors.white, -3, 0, 'right-top');
			maximizeButton:SetOnClick(EventHandler(maximizeButtonClick));
		end
	end

	constructor(_application, _name, _isUnique, _isModal, _title, _x, _y, _width, _height, _backgroundColor, _allowMaximize, _allowMove);
end)
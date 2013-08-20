local Window = Classes.Application.Window;

local Button = Classes.Components.Button;
local VerticalScrollBar = Classes.Components.VerticalScrollBar;
local HorizontalScrollBar = Classes.Components.HorizontalScrollBar;
local PopupMenu = Classes.Components.PopupMenu;

local EnterTextDialog = Classes.System.Windows.EnterTextDialog;
local ColorPickerDialog = Classes.System.Windows.ColorPickerDialog;
local MessageWindow = Classes.System.Windows.MessageWindow;

local Image = Classes.System.Graphics.Image;


BiriPaintWindow = Class(Window, function(this, _application, _fileName)	
	
	Window.init(this, _application, 'Biribitum Paint', false);
	this:SetTitle('Biribitum Paint');
	this:SetX(1);
	this:SetY(2);
	this:SetWidth(41);
	this:SetHeight(17);
	this:SetMinimalWidth(15);
	this:SetMinimalHeight(8);


	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local mode;	
	local isMenuOpen;
	local xDown;
	local yDown;	

	local vScrollBar;
	local hScrollBar;

	local fileMenu;
	local fileButton;
	local newButton;
	local openButton;
	local saveButton;

	local editMenu;
	local editButton;
	local clearButton;
	local undoButton;
	local sizeButton;

	local modeMenu;
	local modeButton;
	local penButton;
	local lineButton;
	local rectButton;
	local ellipseButton;
	local fillButton;

	local image;
	local imageBackup;

	local mainColorSelectionButton;
	local additionalColorSelectionButton;
	


	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------
	
	local function scrollUpdate()	
		vScrollBar:SetValue(1);
		hScrollBar:SetValue(1);
		vScrollBar:SetHeight(this:GetHeight() - 5);
		hScrollBar:SetWidth(this:GetWidth() - 3);
		vScrollBar:SetMaxValue(image:GetHeight() - this:GetHeight() + 7);
		hScrollBar:SetMaxValue(image:GetWidth() - this:GetWidth() + 5);	
	end

	local function undo()	
		if (imageBackup ~= nil) then
			image = Image(imageBackup);
		end	
	end

	---------------------------------------------------
	---Component`s events--------------
	---------------------------------------------------


	local function mainColorPickerOnOk(_sender, _eventArgs)
		mainColorSelectionButton:SetBackgroundColor(_eventArgs.Color);				
	end

	local function additionalColorPickerOnOk(_sender, _eventArgs)
		additionalColorSelectionButton:SetBackgroundColor(_eventArgs.Color);				
	end

	local mainColorSelectionButtonClick = function(_sender, _eventArgs)
		local picker = ColorPickerDialog(this:GetApplication());
		picker:AddOnOkEventHandler(mainColorPickerOnOk);
		picker:ShowModal();
	end

	local additionalColorSelectionButtonClick = function(_sender, _eventArgs)
		local colorPickerDialog = ColorPickerDialog(this:GetApplication());
		colorPickerDialog:AddOnOkEventHandler(additionalColorPickerOnOk);
		colorPickerDialog:ShowModal();
	end


	local fileButtonClick = function(_sender, _eventArgs)
		fileMenu.X = this:GetX() + 1;
		fileMenu.Y = this:GetY() + 2;
		this:OpenCloseMenu('FileMenu');
	end

	local function newDialogOnOk(_sender, _eventArgs)
		local width = _eventArgs.Width;	
		local height = _eventArgs.Height;		
		image = Image(width,height);	
		scrollUpdate();
	end


	local newButtonClick = function(_sender, _eventArgs)
		local newDialog = BiriPaintImageSizeDialog(this:GetApplication(),'New image',''..image:GetWidth(),''..image:GetHeight());
		newDialog:AddOnOkEventHandler(newDialogOnOk);
		newDialog:ShowModal();		
	end

	local function loadImage(_fileName)
		if fs.exists(_fileName) then
			image:LoadFromFile(_fileName);	
			scrollUpdate()
			return true;
			
		end

		return false;	
	end

	local function openDialogOnOk(_sender, _eventArgs)
		local fileName = _eventArgs.Text..'.image';
		if (loadImage(fileName)) then
			local openWindow = MessageWindow(this:GetApplication(), 'File opened', 'File successfully opened.');
			openWindow:ShowModal();
		else
			local errorWindow = MessageWindow(this:GetApplication(), 'File not exist', 'File with name :'.._fileName..' not exist');
			errorWindow:ShowModal();
		end
	end

	local openButtonClick = function(_sender, _eventArgs)
		local openDialog = EnterTextDialog(this:GetApplication(),'Open file','Enter file name','/');
		openDialog:AddOnOkEventHandler(openDialogOnOk);
		openDialog:ShowModal();	
	end
	
	local function saveDialogOnOk(_sender, _eventArgs)
		local fileName = _eventArgs.Text..'.image';		
		image:SaveToFile(fileName);	
		local openWindow = MessageWindow(this:GetApplication(), 'File saved', 'File successfully saved.');
		openWindow:ShowModal();					
	end

	local saveButtonClick = function(_sender, _eventArgs)
		local saveDialog = EnterTextDialog(this:GetApplication(),'Save file','Enter file name','/');
		saveDialog:AddOnOkEventHandler(saveDialogOnOk);
		saveDialog:ShowModal();		
	end


	local editButtonClick = function(_sender, _eventArgs)
		editMenu.X = this:GetX() + 6;
		editMenu.Y = this:GetY() + 2;
		this:OpenCloseMenu('EditMenu');
	end

	local clearButtonClick = function(_sender, _eventArgs)
		imageBackup = Image(image);
		image = Image(image:GetWidth(),image:GetHeight());
	end
		
	local undoButtonClick = function(_sender, _eventArgs)
		undo();	
	end

	local function sizeDialogOnOk(_sender, _eventArgs)
		local width = tonumber(_eventArgs.Width);	
		local height = tonumber(_eventArgs.Height);	
		imageBackup = Image(image);	
		image:SetSize(width,height);					
		scrollUpdate();
	end

	local sizeButtonClick = function(_sender, _eventArgs)
		local sizeDialog = BiriPaintImageSizeDialog(this:GetApplication(),'New image size',''..image:GetWidth(),''..image:GetHeight());
		sizeDialog:AddOnOkEventHandler(sizeDialogOnOk);
		sizeDialog:ShowModal();		
	end


	local modeButtonClick = function(_sender, _eventArgs)
		modeMenu.X = this:GetX() + 6;
		modeMenu.Y = this:GetY() + this:GetHeight() - modeMenu.Height - 2;
		this:OpenCloseMenu('ModeMenu');
	end

	local toolButtonClick = function(_sender, _eventArgs)
		mode =_sender:GetText();
		modeButton:SetText(mode);
	end	

	local function getXOnImage(_cursorX)
		local pointX = _cursorX - this:GetX() - 1 + hScrollBar:GetValue();
		return pointX;
	end

	local function getYOnImage(_cursorY)
		local pointY = _cursorY - this:GetY() - 2 + vScrollBar:GetValue();
		return pointY;
	end	

	---------------------------------------------------
	---Draw function--------------------------
	---------------------------------------------------
	
	local paintPixel = function(_x, _y, _color)			
		if (_y >= vScrollBar:GetValue() and _y <= this:GetHeight() + vScrollBar:GetValue() - 6 and _x >= 1 and _x <= this:GetWidth() - 4 + hScrollBar:GetValue()) then				
			image:SetPixel(_x, _y,_color);
		end
		return true;		
	end	

	local fill = function(_x, _y, _color)
		local added = 1;
		local toFill = image:GetPixel(_x, _y)
		image:SetPixel(_x, _y,-100);
		while (added > 0) do
			added = 0;
			for i = 1, image:GetWidth() do
				for j = 1, image:GetHeight() do
					if (image:GetPixel(i, j) == toFill and
						(image:GetPixel(i- 1, j) == -100 or
						image:GetPixel(i + 1, j) == -100 or
						image:GetPixel(i, j - 1) == -100 or
						image:GetPixel(i, j + 1) == -100)) then
							image:SetPixel(i, j,-100);
						added = added + 1;
					end
				end
			end
		end		
		for i = 1,image:GetWidth() do
			for j = 1, image:GetWidth() do
				if (image:GetPixel(i, j) == -100) then
					image:SetPixel(i, j,_color);
				end
			end
		end		
	end

	local paintLine = function(_x1, _y1, _x2, _y2, _color)		
		image:DrawLine(_color, _x1, _y1, _x2, _y2);
		return true;
	end

	local paintRect = function(_x1, _y1, _x2, _y2, _color)	
		local width = math.abs(_x1-_x2);
		local height = math.abs(_y1-_y2);				
		local minX = math.min(_x1,_x2);
		local minY = math.min(_y1,_y2);	
		image:DrawRect(_color, minX,minY,width,height);
		return true;
	end

	local paintEllipse = function(_x1, _y1, _x2, _y2, _color)	
		local width = math.abs(_x1-_x2);
		local height = math.abs(_y1-_y2);				
		local minX = math.min(_x1,_x2);
		local minY = math.min(_y1,_y2);	
		image:DrawEllipse(_color, minX,minY,width,height);
		return true;
	end

	

	----------------------------------------------------
	---Window Event--------------------------
	----------------------------------------------------
	
	

	local function onWindowResize(_sender, _eventArgs)		
		scrollUpdate();	
	end

	function this.ProcessLeftClickEvent(_, _cursorX, _cursorY)
		imageBackup = Image(image);	
		if (mode == 'Pen    ') then	
			return paintPixel(getXOnImage(_cursorX), getYOnImage(_cursorY), mainColorSelectionButton:GetBackgroundColor());
		elseif(mode == 'Fill   ') then
			fill(getXOnImage(_cursorX), getYOnImage(_cursorY), mainColorSelectionButton:GetBackgroundColor());
		elseif(mode == 'Line   ') then			
			xDown = getXOnImage(_cursorX);
			yDown = getYOnImage(_cursorY);
		elseif(mode == 'Rect   ') then			
			xDown = getXOnImage(_cursorX);
			yDown = getYOnImage(_cursorY);
		elseif(mode == 'Ellipse') then			
			xDown = getXOnImage(_cursorX);
			yDown = getYOnImage(_cursorY);
		end
	end

	function this.ProcessRightClickEvent(_, _cursorX, _cursorY)
		imageBackup = Image(image);
		if (mode == 'Pen    ') then
			return paintPixel(getXOnImage(_cursorX), getYOnImage(_cursorY), additionalColorSelectionButton:GetBackgroundColor());
		elseif(mode == 'Fill   ') then
			fill(getXOnImage(_cursorX), getYOnImage(_cursorY), additionalColorSelectionButton:GetBackgroundColor());
		elseif(mode == 'Line   ') then			
			xDown = getXOnImage(_cursorX);
			yDown = getYOnImage(_cursorY);
		elseif(mode == 'Rect   ') then			
			xDown = getXOnImage(_cursorX);
			yDown = getYOnImage(_cursorY);
		elseif(mode == 'Ellipse') then			
			xDown = getXOnImage(_cursorX);
			yDown = getYOnImage(_cursorY);
		end
	end
	
	function this.ProcessLeftMouseDragEvent(_, _newCursorX, _newCursorY)
		if (mode == 'Pen    ') then
			return paintPixel(getXOnImage(_newCursorX), getYOnImage(_newCursorY), mainColorSelectionButton:GetBackgroundColor());	
		elseif(mode == 'Line   ') then
			image = Image(imageBackup);
			return paintLine(xDown, yDown, getXOnImage(_newCursorX), getYOnImage(_newCursorY), mainColorSelectionButton:GetBackgroundColor());
		elseif(mode == 'Rect   ') then
			image = Image(imageBackup);
			return paintRect(xDown, yDown, getXOnImage(_newCursorX), getYOnImage(_newCursorY), mainColorSelectionButton:GetBackgroundColor());
		elseif(mode == 'Ellipse') then
			image = Image(imageBackup);
			return paintEllipse(xDown, yDown, getXOnImage(_newCursorX), getYOnImage(_newCursorY), mainColorSelectionButton:GetBackgroundColor());
		end	
	end

	function this.ProcessRightMouseDragEvent(_, _newCursorX, _newCursorY)
		if (mode == 'Pen    ') then
			return paintPixel(getXOnImage(_newCursorX), getYOnImage(_newCursorY), additionalColorSelectionButton:GetBackgroundColor());	
		elseif(mode == 'Line   ') then
			image = Image(imageBackup);
			return paintLine(xDown, yDown, getXOnImage(_newCursorX), getYOnImage(_newCursorY), additionalColorSelectionButton:GetBackgroundColor());	
		elseif(mode == 'Rect   ') then
			image = Image(imageBackup);
			return paintRect(xDown, yDown, getXOnImage(_newCursorX), getYOnImage(_newCursorY), additionalColorSelectionButton:GetBackgroundColor());
		elseif(mode == 'Ellipse') then
			image = Image(imageBackup);
			return paintEllipse(xDown, yDown, getXOnImage(_newCursorX), getYOnImage(_newCursorY), additionalColorSelectionButton:GetBackgroundColor());
		end	
	end	

	function this.ProcessKeyEvent(_, key)
		if (keys.getName(key) == 'z') then
			undo();			
		end
	end

	function this.Update()
			
	end

	local drawImage = function(videoBuffer)
		local scrollY = vScrollBar:GetValue();
		local scrollX = hScrollBar:GetValue();
		local bottom = this:GetHeight() - 6 + scrollY;
		local right = this:GetWidth() - 4 + scrollX;
		if (bottom > image:GetHeight()) then
			bottom = image:GetHeight();
		end
		if (right > image:GetWidth()) then
			right = image:GetWidth();
		end
		for i = scrollY, bottom do
			for j = scrollX, right do
				local color = image:GetPixel(j, i);				
				videoBuffer:SetPixelColor(j + 1 - scrollX, i + 2 - scrollY, color);				
			end
		end
	end

	function this.Draw(_, videoBuffer)
		drawImage(videoBuffer);	
	end	

	

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()		

		vScrollBar = VerticalScrollBar(1, 9, 12, nil, nil, 0, 1, 'right-top');	
		this:AddComponent(vScrollBar);

		hScrollBar = HorizontalScrollBar(1,15, 38, nil, nil, 0, 1, 'left-bottom');	
		this:AddComponent(hScrollBar);		
		
		image = Image(51,19);

		mainColorSelectionButton = Button('  ', colors.black, nil, 0, 0, 'left-bottom');
		mainColorSelectionButton:AddOnClickEventHandler(mainColorSelectionButtonClick);		
		this:AddComponent(mainColorSelectionButton);

		additionalColorSelectionButton = Button('  ', colors.white, nil, 2, 0, 'left-bottom');		
		additionalColorSelectionButton:AddOnClickEventHandler(additionalColorSelectionButtonClick);
		this:AddComponent(additionalColorSelectionButton);		

		----------------------
		---Mode menu
		----------------------

		modeMenu = PopupMenu(6, 4, 15, 11, nil);
		this:AddMenu('ModeMenu', modeMenu);

		modeButton = Button('Pen    ', nil, nil, 5, 0, 'left-bottom');
		modeButton:AddOnClickEventHandler(modeButtonClick);
		this:AddComponent(modeButton);

		penButton = Button('Pen    ', nil, nil, 1, 1, 'left-top');
		penButton:AddOnClickEventHandler(toolButtonClick);
		modeMenu:AddComponent(penButton);

		lineButton = Button('Line   ', nil, nil, 1, 3, 'left-top');
		lineButton:AddOnClickEventHandler(toolButtonClick);
		modeMenu:AddComponent(lineButton);

		rectButton = Button('Rect   ', nil, nil, 1, 5, 'left-top');
		rectButton:AddOnClickEventHandler(toolButtonClick);
		modeMenu:AddComponent(rectButton);

		ellipseButton = Button('Ellipse', nil, nil, 1, 7, 'left-top');
		ellipseButton:AddOnClickEventHandler(toolButtonClick);
		modeMenu:AddComponent(ellipseButton);

		fillButton = Button('Fill   ', nil, nil, 1, 9, 'left-top');
		fillButton:AddOnClickEventHandler(toolButtonClick);
		modeMenu:AddComponent(fillButton);

		----------------------
		---File menu
		----------------------

		fileMenu = PopupMenu(2, 4, 15, 7, nil);
		this:AddMenu('FileMenu', fileMenu);		

		fileButton = Button('File', nil, nil, 0, 0, 'left-top');
		fileButton:AddOnClickEventHandler(fileButtonClick);
		this:AddComponent(fileButton);

		newButton = Button('New', nil, nil, 1, 1, 'left-top');
		newButton:AddOnClickEventHandler(newButtonClick);
		fileMenu:AddComponent(newButton);

		openButton = Button('Open', nil, nil, 1, 3, 'left-top');
		openButton:AddOnClickEventHandler(openButtonClick);
		fileMenu:AddComponent(openButton);

		saveButton = Button('Save', nil, nil, 1, 5, 'left-top');
		saveButton:AddOnClickEventHandler(saveButtonClick);
		fileMenu:AddComponent(saveButton);
		
		----------------------
		---Edit menu
		----------------------
		
		editMenu = PopupMenu(2, 4, 15, 7, nil);
		this:AddMenu('EditMenu', editMenu);	

		editButton = Button('Edit', nil, nil, 5, 0, 'left-top');
		editButton:AddOnClickEventHandler(editButtonClick);
		this:AddComponent(editButton);

		clearButton = Button('Clear all', nil, nil, 1, 1, 'left-top');
		clearButton:AddOnClickEventHandler(clearButtonClick);
		editMenu:AddComponent(clearButton);
		
		undoButton = Button('Undo', nil, nil, 1, 3, 'left-top');
		undoButton:AddOnClickEventHandler(undoButtonClick);
		editMenu:AddComponent(undoButton);

		sizeButton = Button('Set size', nil, nil, 1, 5, 'left-top');
		sizeButton:AddOnClickEventHandler(sizeButtonClick);
		editMenu:AddComponent(sizeButton);


		this:AddOnResizeEventHandler(onWindowResize);

	end

	local function constructor(_application, _fileName)		
		mode = 'Pen    ';		
		isMenuOpen = false;
		xDown = 0;
		yDown = 0;
		initializeComponents();

		if (_fileName) then
			loadImage(_fileName);
		end
	end

	constructor(_application, _fileName);
end)
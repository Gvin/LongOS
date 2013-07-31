PaintWindow = Class(Window, function(this, application)
	Window.init(this, application, 5, 2, 41, 17, true, true, nil, 'Paint window', 'Gvin paint', false);

	local canvasHeight = 19;
	local canvasWidth = 51;
	this.FileName = '/default.image#'..canvasWidth..'x'..canvasHeight;	
	canvas = {};
	for i = 1, 19 do
		canvas[i] = {};
		for j = 1, 51 do
			canvas[i][j] = colors.white;
		end
	end
	local oldFileName = this.FileName;
	this.IsLoading = false;
	local fileToLoad = {};
	fileToLoad.FileName = '';
	this.IsFilling = false;

	local mainColor = {};
	mainColor.BackgroundColor = colors.black;
	local additionalColor = {};
	additionalColor.BackgroundColor = colors.white;

	local newFileButtonClick = function(sender, eventArgs)
		local openFileWindow = OpenFileWindow(application, this, 'New file', this.FileName);
		openFileWindow:Show();
	end

	local newFileButton = Button('New', nil, nil, 1, 1, 'left-top');
	newFileButton:SetOnClick(EventHandler(newFileButtonClick));
	this:AddComponent(newFileButton);

	local openFileButtonClick = function(sender, eventArgs)
		local openFileWindow = OpenFileWindow(application, fileToLoad, 'Opening file', '');
		openFileWindow:Show();
		this.IsLoading = true;
		fileToLoad.FileName = '';
	end

	local openFileButton = Button('Open', nil, nil, 5, 1, 'left-top');
	openFileButton:SetOnClick(EventHandler(openFileButtonClick));
	this:AddComponent(openFileButton);

	local saveFileButtonClick = function(sender, eventArgs)
		this:SaveFile();
	end

	local saveFileButton = Button('Save', nil, nil, 10, 1, 'left-top');
	saveFileButton:SetOnClick(EventHandler(saveFileButtonClick));
	this:AddComponent(saveFileButton);

	local clearButtonClick = function(sender, eventArgs)
		this:Clear();
	end

	local clearButton = Button('Clear', nil, nil, 15, 1, 'left-top');
	clearButton:SetOnClick(EventHandler(clearButtonClick));
	this:AddComponent(clearButton);

	local colorSelectionButtonClick = function(sender, eventArgs)
		local picker = ColorPickerWindow(application, sender:GetBackgroundColor(), {});
		picker:Show();
	end

	local mainColorSelectionButton = Button('  ', mainColor.BackgroundColor, nil, 1, -2, 'left-bottom');
	mainColorSelectionButton:SetOnClick(EventHandler(colorSelectionButtonClick));
	this:AddComponent(mainColorSelectionButton);

	local additionalColorSelectionButton = Button('  ', additionalColor.BackgroundColor, nil, 3, -2, 'left-bottom');
	additionalColorSelectionButton:SetOnClick(EventHandler(colorSelectionButtonClick));
	this:AddComponent(additionalColorSelectionButton);

	local fillToolButtonClick = function(sender, eventArgs)
		this.IsFilling = true;
	end

	local fillToolButton = Button('Fill', nil, nil, 6, -2, 'left-bottom');
	fillToolButton:SetOnClick(EventHandler(fillToolButtonClick));
	this:AddComponent(fillToolButton);

	local vScrollBar = VerticalScrollBar(1, 7, 13, nil, nil, -2, 2, 'right-top');
	vScrollBar:SetValue(1);
	this:AddComponent(vScrollBar);

	local hScrollBar = HorizontalScrollBar(1,17, 38, nil, nil, 1, -3, 'left-bottom');
	hScrollBar:SetValue(1);
	this:AddComponent(hScrollBar);

	local function getImageSize(file)
		local size = stringExtAPI.separate(file.readLine(),'x');
		return size[1] + 0, size[2] + 0;
	end

	this.LoadFile = function(_)
		local fileName = stringExtAPI.separate(this.FileName, '#')[1];
		local file = fs.open(fileName, 'r');
		canvasWidth, canvasHeight = getImageSize(file);
		canvas = {};
		for i = 1, canvasHeight do
			local line = file.readLine();
			canvas[i] = stringExtAPI.separate(line, ' ');
			for j = 1, canvasWidth do
				canvas[i][j] = canvas[i][j] + 0;
			end
		end

		file.close();
		System:ShowModalMessage(this._application, 'File opened', 'File successfully opened.');
	end

	this.Update = function(_)
		this.Title = 'Gvin paint : '..this.FileName;
		vScrollBar.Height = this.Height - 4;
		hScrollBar.Width = this.Width - 3;
		vScrollBar:SetMaxValue(canvasHeight - 6);
		hScrollBar:SetMaxValue(canvasWidth - 13);
		mainColorSelectionButton.BackgroundColor = mainColor.BackgroundColor;
		additionalColorSelectionButton.BackgroundColor = additionalColor.BackgroundColor;

		if (this.IsLoading) then
			if (fileToLoad.FileName ~= '') then
				local file = fs.open(fileToLoad.FileName, 'r');
				canvasWidth, canvasHeight = getImageSize(file);
				file.close();
				this.FileName = fileToLoad.FileName..'#'..canvasWidth..'x'..canvasHeight;
				this:LoadFile();
				this.IsLoading = false;
				fileToLoad.FileName = '';
				oldFileName = this.FileName;
			end
		else
			if (this.FileName ~= oldFileName) then
				local sizeString = stringExtAPI.separate(this.FileName, '#')[2];
				local size = stringExtAPI.separate(sizeString, 'x');
				canvasWidth = size[1] + 0;
				canvasHeight = size[2] + 0;
				this:Clear();
				oldFileName = this.FileName;
			end
		end
	end

	local drawCanvas = function(videoBuffer)
		local scrollY = vScrollBar:GetValue();
		local scrollX = hScrollBar:GetValue();
		local bottom = this.Height - 6 + scrollY;
		local right = this.Width - 4 + scrollX;
		if (bottom > canvasHeight) then
			bottom = canvasHeight;
		end
		if (right > canvasWidth) then
			right = canvasWidth;
		end
		for i = scrollY, bottom do
			for j = scrollX, right do
				videoBuffer:SetPixelColor(j + this.X + 1 - scrollX, i + this.Y + 2 - scrollY, canvas[i][j]);
			end
		end
	end

	this.Clear = function(_)
		canvas = {};
		for i = 1, canvasHeight do
			canvas[i] = {};
			for j = 1, canvasWidth do
				canvas[i][j] = colors.white;
			end
		end
	end

	this.Draw = function(_, videoBuffer)
		drawCanvas(videoBuffer);
	end

	local getPixel = function(i, j)
		if (i >= 1 and i <= canvasHeight and j >= 1 and j <= canvasWidth) then
			return canvas[i][j];
		end
		return nil;
	end

	local fill = function(pointX, pointY, color)
		local added = 1;
		local toFill = canvas[pointY][pointX];
		canvas[pointY][pointX] = -100;
		while (added > 0) do
			added = 0;
			for i = 1, canvasHeight do
				for j = 1, canvasWidth do
					if (canvas[i][j] == toFill and
						(getPixel(i - 1, j) == -100 or
						getPixel(i + 1, j) == -100 or
						getPixel(i, j - 1) == -100 or
						getPixel(i, j + 1) == -100)) then
						canvas[i][j] = -100;
						added = added + 1;
					end
				end
			end
		end

		for i = 1,canvasHeight do
			for j = 1, canvasWidth do
				if (canvas[i][j] == -100) then
					canvas[i][j] = color;
				end
			end
		end

		this.IsFilling = false;
	end

	local paintPixel = function(cursorX, cursorY, color)
		if (this:Contains(cursorX, cursorY)) then
			local pointX = cursorX - this.X - 1 + hScrollBar:GetValue();
			local pointY = cursorY - this.Y - 2 + vScrollBar:GetValue();
			if (pointY >= vScrollBar:GetValue() and pointY <= this.Height + vScrollBar:GetValue() - 6 and pointX >= 1 and pointX <= this.Width - 4 + hScrollBar:GetValue()) then
				if (this.IsFilling) then
					fill(pointX, pointY, color);
				else
					canvas[pointY][pointX] = color;
				end
			end
			return true;
		end
		return false
	end

	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		return paintPixel(cursorX, cursorY, mainColor.BackgroundColor);
	end

	this.ProcessRightClickEvent = function(_, cursorX, cursorY)
		return paintPixel(cursorX, cursorY, additionalColor.BackgroundColor);
	end

	this.SaveFile = function(_)
		local fileName = stringExtAPI.separate(this.FileName, '#')[1];
		local file = fs.open(fileName, 'w');
		file.writeLine(canvasWidth..'x'..canvasHeight);
		local line = '';
		for i = 1, canvasHeight do
			line = '';
			for j = 1, canvasWidth do
				line = line..canvas[i][j]..' ';
			end
			file.writeLine(line);
		end

		file.close();
		System:ShowModalMessage(this._application, 'File saved', 'File successfully saved.');
	end
end)
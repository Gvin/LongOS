local function copyButtonClick(params)
	params[1]:Copy();
end

local function cutButtonClick(params)
	params[1]:Cut();
end

local function pasteButtonClick(params)
	params[1]:Paste();
end

local function deleteFile(params)
	params[1]:Delete(params[2]);
end

local function renameButtonClick(params)
	params[1]:Rename();
	local openFileWindow = OpenFileWindow(params[2], params[3], 'Rename file', params[3].OldFileName);
	openFileWindow:Show();
end

local function createDirectoryButtonClick(params)
	params[2].FileName = '';
	local openFileWindow = OpenFileWindow(params[1], params[2], 'Create directory', '');
	openFileWindow:Show();
	params[3].CreatingDirectory = true;
end

local function createFileButtonClick(params)
	params[2].FileName = '';
	local openFileWindow = OpenFileWindow(params[1], params[2], 'Create file', '');
	openFileWindow:Show();
	params[3].CreatingFile = true;
end

FileManagerWindow = Class(Window, function(this, application)
	Window.init(this, application, 5, 3, 40, 11, true, true, nil, 'File manager window', 'Gvin file manager', false);

	local currentDirectory = '/';
	local selectedFile = '';
	local copiedFile = '';
	local cuttedFile = '';
	local newDirectory = {};
	local newFile = {};
	local renamingFile = {};
	this.CreatingDirectory = false;
	this.CreatingFile = false;
	this.Renaming = false;

	local vScrollBar = VerticalScrollBar(0, 10, 7, nil, nil, -2, 2, 'right-top');
	this:AddComponent(vScrollBar);

	local pasteButton = Button('Paste', nil, nil, 1, -2, 'left-bottom');
	pasteButton.OnClick = pasteButtonClick;
	pasteButton.OnClickParams = { this };
	this:AddComponent(pasteButton);

	local createDirectoryButton = Button('Create directory', nil, nil, 7, -2, 'left-bottom');
	createDirectoryButton.OnClick = createDirectoryButtonClick;
	createDirectoryButton.OnClickParams = { application, newDirectory, this };
	this:AddComponent(createDirectoryButton);

	local createFileButton = Button('Create file', nil, nil, 24, -2, 'left-bottom');
	createFileButton.OnClick = createFileButtonClick;
	createFileButton.OnClickParams = { application, newFile, this };
	this:AddComponent(createFileButton);

	local contextMenu = PopupMenu(1, 1, 10, 9, nil, true);
	this:AddMenu('ContextMenu', contextMenu);

	local copyButton = Button('Copy', nil, nil, 1, 1, 'left-top');
	copyButton.OnClick = copyButtonClick;
	copyButton.OnClickParams = { this };
	contextMenu:AddComponent(copyButton);

	local cutButton = Button('Cut', nil, nil, 1, 3, 'left-top');
	cutButton.OnClick = cutButtonClick;
	cutButton.OnClickParams = { this };
	contextMenu:AddComponent(cutButton);

	local function deleteButtonClick()
		local dialogWindow = DialogWindow(application, 'Delete?', 'Do you really want to delete     '..selectedFile..'?');
		dialogWindow.OnOkClick = deleteFile;
		dialogWindow.OnOkClickParams = { this, selectedFile };
		dialogWindow:Show();
	end

	local deleteButton = Button('Delete', nil, nil, 1, 5, 'left-top');
	deleteButton.OnClick = deleteButtonClick;
	contextMenu:AddComponent(deleteButton);

	local renameButton = Button('Rename', nil, nil, 1, 7, 'left-top');
	renameButton.OnClick = renameButtonClick;
	renameButton.OnClickParams = { this, application, renamingFile };
	contextMenu:AddComponent(renameButton);

	local getFiles = function(_)
		local files =  fs.list(currentDirectory);
		table.insert(files, '..');
		table.sort(files);
		return files;
	end

	local findCurrentDirectoryToPrint = function(_)
		local currentDirectoryToPrint = currentDirectory;
		if (string.len(currentDirectoryToPrint) > this.Width - 4) then
			local toCut = string.len(currentDirectoryToPrint) - this.Width + 12;
			currentDirectoryToPrint = '...'..string.sub(currentDirectoryToPrint, toCut, string.len(currentDirectoryToPrint));
		end

		return currentDirectoryToPrint;
	end

	local writeCurrentDirectory = function(videoBuffer)
		videoBuffer:SetColorParameters(colors.red, System:GetSystemColor('WindowColor'));

		local currentDirectoryToPrint = findCurrentDirectoryToPrint();

		videoBuffer:WriteAt(this.X + 1, this.Y + this.Height - 3, currentDirectoryToPrint);
	end

	this.Draw = function(_, videoBuffer)
		vScrollBar.Height = this.Height - 5;
		local files = getFiles();
		
		videoBuffer:SetBackgroundColor(colors.white);
		videoBuffer:DrawBlock(this.X + 1, this.Y + 2, this.Width - 3, this.Height - 5, colors.white);
		local lastLine = #files;
		if (lastLine > this.Height - 5 + vScrollBar:GetValue()) then
			lastLine = this.Height - 5 + vScrollBar:GetValue();
		end
		for i = vScrollBar:GetValue() + 1, lastLine do
			videoBuffer:SetCursorPos(this.X + 1, this.Y + i + 1 - vScrollBar:GetValue());
			if (fs.isDir(currentDirectory..'/'..files[i]) or files[i] == '..') then
				videoBuffer:SetTextColor(colors.blue);
			else
				videoBuffer:SetTextColor(colors.green);
			end
			if (selectedFile == files[i]) then
				videoBuffer:SetBackgroundColor(colors.lightBlue);
			else
				videoBuffer:SetBackgroundColor(colors.white);
			end
			videoBuffer:Write(files[i]);
		end

		writeCurrentDirectory(videoBuffer);
	end

	local createDirectory = function()
		local newDirectoryName = currentDirectory..'/'..newDirectory.FileName;
		if (fs.exists(newDirectoryName)) then
			System:ShowModalMessage(application, 'Directory exists', '   Directory with such name          allready exists.');
		else
			fs.makeDir(newDirectoryName);
		end
		this.CreatingDirectory = false;
		newDirectory.FileName = '';
	end

	local createFile = function()
		local newFileName = currentDirectory..'/'..newFile.FileName;
		if (fs.exists(newFileName)) then
			System:ShowModalMessage(application, 'File exists', ' File or directory with such     name allready exists.');
		else
			local descryptor = fs.open(newFileName, 'w');
			descryptor.close();
		end
		this.CreatingFile = false;
		newFile.FileName = '';
	end

	local renameFile = function()
		local newFileName = currentDirectory..'/'..renamingFile.FileName;
		local oldFileName = currentDirectory..'/'..renamingFile.OldFileName;
		if (fs.exists(newFileName)) then
			System:ShowModalMessage(application, 'File exists', ' File or directory with such     name allready exists.');
		else
			fs.copy(oldFileName, newFileName);
			fs.delete(oldFileName);
		end
		this.Renaming = false;
		renamingFile.FileName = '';
		renamingFile.OldFileName = '';
	end

	this.Update = function(_)
		local files = getFiles();
		if (#files > 1) then
			vScrollBar:SetMaxValue(#files - 1);
		else
			vScrollBar:SetMaxValue(1);
		end

		if (this.CreatingDirectory and newDirectory.FileName ~= '') then
			createDirectory();
		end

		if (this.CreatingFile and newFile.FileName ~= '') then
			createFile();
		end

		if (this.Renaming and renamingFile.FileName ~= '') then
			renameFile();
		end
	end

	local back = function(_)
		selectedFile = '';
		vScrollBar:SetValue(0);
		if (currentDirectory ~= '/') then
			local i = string.len(currentDirectory);
			local endPos = 0;
			while (i >= 1 and endPos == 0) do
				if (string.sub(currentDirectory, i, i) == '/') then
					endPos = i;
				end
				i = i - 1;
			end
			currentDirectory = ''..string.sub(currentDirectory, 1, endPos - 1);
		end
	end

	local processFileSelection = function(cursorX, cursorY)
		if (cursorX < this.X + this.Width - 3) then
			local files = getFiles();
			local clickedLine = cursorY - 1 - this.Y + vScrollBar:GetValue();
			if (files[clickedLine] ~= nil) then
				if (files[clickedLine] == '..') then
					selectedFile = '';
				else
					selectedFile = files[clickedLine];
				end
			else
				selectedFile = '';
			end
		end
	end

	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		processFileSelection(cursorX, cursorY);
	end

	this.ProcessRightClickEvent = function(_, cursorX, cursorY)
		this:CloseAllMenues();
		processFileSelection(cursorX, cursorY);
		if (selectedFile ~= '') then
			contextMenu.X = cursorX;
			contextMenu.Y = cursorY;
			this:OpenMenu('ContextMenu');
		end
		return this:Contains(cursorX, cursorY);
	end

	this.ProcessDoubleClickEvent = function(_, cursorX, cursorY)
		if (cursorX < this.X + this.Width - 3) then
			local files = getFiles();

			local clickedLine = cursorY - 1 - this.Y + vScrollBar:GetValue();
			if (files[clickedLine] ~= nil) then
				local clickedFile = currentDirectory..'/'..files[clickedLine];
				if (files[clickedLine] == '..') then
					back();
				elseif (fs.isDir(clickedFile)) then
					currentDirectory = clickedFile;
					vScrollBar:SetValue(0);
					selectedFile = '';
				end
			end
		end
	end

	this.Copy = function(_)
		copiedFile = currentDirectory..'/'..selectedFile;
		cuttedFile = '';
	end

	this.Cut = function(_)
		cuttedFile =  currentDirectory..'/'..selectedFile;
		copiedFile = '';
	end

	local resetCopyCut = function()
		cuttedFile = '';
		copiedFile = '';
	end

	local function copyFile(fileName, accessPath)
		if (fs.isDir(fileName)) then
			local newPathParts = stringExtAPI.separate(accessPath, '/');
			local oldPathParts = stringExtAPI.separate(fileName, '/');
			local name = fs.getName(fileName);
			local equal = true;
			for i = 1, #oldPathParts do
				if (oldPathParts[i] ~= newPathParts[i]) then
					equal = false;
				end
			end
			if (equal) then
				return false;
			end
		end
		fs.copy(fileName, accessPath);
		return true;
	end

	this.Paste = function(_)
		local fileName = '';
		if (copiedFile ~= '') then
			fileName = copiedFile;
		end
		if (cuttedFile ~= '') then
			fileName = cuttedFile;
		end
		local name = fs.getName(fileName);
		if (fileName ~= '') then
			local accessPath = currentDirectory..'/'..name;
			if (fs.exists(accessPath)) then
				System:ShowMessage('File exists', 'File "'..name..'" allready exists in current directory.');
				resetCopyCut();
				return;
			end
			if (not copyFile(fileName, accessPath)) then
				System:ShowMessage('Wrong operation', "Can't copy directory inside itself.");
				resetCopyCut();
			end
		end
		if (cuttedFile ~= '') then
			fs.delete(cuttedFile);
		end
		resetCopyCut();
	end

	this.Delete = function(_, fileName)
		if (fileName ~= '' and fileName ~= nil) then
			fs.delete(currentDirectory..'/'..fileName);
		end
	end

	this.ProcessKeyEvent = function(_, key)
		if (keys.getName(key) == 'delete') then
			deleteButtonClick();
		end
	end

	this.Rename = function(_)
		if (selectedFile ~= '') then
			this.Renaming = true;
			renamingFile.OldFileName = selectedFile;
			renamingFile.FileName = '';
		end
	end
end)
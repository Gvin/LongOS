local function buttonOkClick(params)
	params[1]:Ok();
end

local function buttonCancelClick(params)
	params[1]:Cancel();
end

OpenFileWindow = Class(Window, function(this, application, owner, title, fileName)
	Window.init(this, application, 10, 7, 30, 7, false, false, nil, 'Open file window', title, true);

	this.owner = owner;
	this.IsModal = true;

	local buttonOk = Button('OK', nil, nil, 1, -2, 'left-bottom');
	buttonOk.OnClick = buttonOkClick;
	buttonOk.OnClickParams = { this };
	this:AddComponent(buttonOk);

	local buttonCancel = Button('Cancel', nil, nil, -7, -2, 'right-bottom');
	buttonCancel.OnClick = buttonCancelClick;
	buttonCancel.OnClickParams = { this };
	this:AddComponent(buttonCancel);

	local fileNameLabel = Label('Enter full file name:', nil, nil, 2, 2, 'left-top');
	this:AddComponent(fileNameLabel);

	local fileNameEdit = Edit(26, colors.white, colors.black, 2, 3, 'left-top');
	fileNameEdit.Text = fileName;
	fileNameEdit:SetFocus(true);
	this:AddComponent(fileNameEdit);

	this.Ok = function(_)
		this.owner.FileName = fileNameEdit.Text;
		this:Close();
	end

	this.Cancel = function(_)
		this.Close();
	end

	this.ProcessKeyEvent = function(_, key)
		if (keys.getName(key) == 'enter') then
			this:Ok();
		end
	end
end)
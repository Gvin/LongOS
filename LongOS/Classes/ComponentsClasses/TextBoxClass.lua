TextBox = Class(Component, function(this, width, height, backgroundColor, textColor, dX, dY, anchorType)
	Component.init(this, dX, dY, anchorType);

	this.Width = width;
	this.Height = height;
	this.BackgroundColor = backgroundColor;
	this.TextColor = textColor;
	this.Text = '';

	local focus = false;
	local mig = 0;

	this._draw = function(videoBuffer, x, y)
		this.X = x;
		this.Y = y;

		videoBuffer:DrawBlock(this.X, this.Y, this.Width, this.Height, this.BackgroundColor);
		videoBuffer:SetColorParameters(this.TextColor, this.BackgroundColor);

		local lines = stringExtAPI.separate(this.Text, '\n', false);

		local toPrint = '';
		if (#lines > 0) then
			for i = 1, #lines do
				toPrint = lines[i];
				videoBuffer:WriteAt(this.X, this.Y + i - 1, toPrint);
			end
		end

		if (focus) then
			videoBuffer:SetRealCursorPos(this.X + string.len(toPrint), this.Y + #lines - 1);
			videoBuffer:SetCursorBlink(true);
		end
	end

	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		if (cursorX >= this.X and cursorX < this.X + this.Width and cursorY >= this.Y and cursorY < this.Y + this.Height) then
			focus = true;
		else
			focus = false;
		end
	end

	local deleteChar = function()
		if (string.len(this.Text) <= 1) then
			this.Text = '';
		else
			this.Text = ''..string.sub(this.Text, 1, string.len(this.Text) - 1);
		end
	end

	local newLine = function()
		local lines = stringExtAPI.separate(this.Text, '\n', false);
		if (#lines < this.Height) then
			this.Text = this.Text..'\n';
		end
	end

	this.ProcessKeyEvent = function(_, key)
		if (focus) then
			local keyName = keys.getName(key);
			if (keyName == 'backspace') then
				deleteChar();
			elseif (keyName == 'enter') then
				newLine();
			end
		end
	end

	this.ProcessCharEvent = function(_, char)
		if (focus) then
			local lines = stringExtAPI.separate(this.Text, '\n', false);
			if (string.len(lines[#lines]) < this.Width - 1) then
				this.Text = this.Text..char;
			end
			if (string.len(lines[#lines]) >= this.Width - 1) then
				newLine();
			end
		end
	end

	this.SetFocus = function(_, newFocus)
		focus = newFocus;
	end
end)
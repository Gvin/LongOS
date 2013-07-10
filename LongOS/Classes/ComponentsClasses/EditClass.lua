Edit = Class(Component, function(this, width, backgroundColor, textColor, dX, dY, anchorType)
	Component.init(this, dX, dY, anchorType);
	this.ClassName = 'Edit';

	local cursorPosition = 0;

	this.BackgroundColor = backgroundColor;
	if (this.BackgroundColor == nil) then
		this.BackgroundColor = System:GetSystemColor('SystemEditsBackgroundColor');
	end
	this.TextColor = textColor;
	if (this.TextColor == nil) then
		this.TextColor = System:GetSystemColor('SystemLabelsTextColor');
	end
	this.Text = '';
	this.X = dX;
	this.Y = dY;
	this.Width = width;

	local focus = false;
	local mig = 0;

	this._draw = function(videoBuffer, x, y)
		this.X = x;
		this.Y = y;

		videoBuffer:DrawBlock(x, y, this.Width, 1, this.BackgroundColor);
		videoBuffer:SetColorParameters(this.TextColor, this.BackgroundColor);

		local toPrint = this.Text;

		if (cursorPosition > string.len(toPrint)) then
			cursorPosition = string.len(toPrint);
		end

		if (cursorPosition > this.Width - 2) then
			toPrint = ''..string.sub(toPrint, cursorPosition - this.Width + 2, cursorPosition);
		end

		if (string.len(toPrint) > this.Width - 2) then
			toPrint = ''..string.sub(toPrint, 1, this.Width - 1);
		end

		if (focus) then
			local realCursorPosition = cursorPosition;
			if (realCursorPosition > this.Width - 1) then
				realCursorPosition = this.Width - 1;
			end
			videoBuffer:SetRealCursorPos(this.X + realCursorPosition, this.Y);
			videoBuffer:SetCursorBlink(true);
		end

		videoBuffer:WriteAt(x, y, toPrint);
	end

	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		if (cursorX >= this.X and cursorX < this.X + this.Width and cursorY == this.Y) then
			focus = true;
		else
			focus = false;
		end
	end

	local processBackspaceKey = function()
		if (string.len(this.Text) <= 1 and cursorPosition ~= 0) then
			this.Text = '';
			cursorPosition = 0;
		elseif (cursorPosition ~= 0) then
			this.Text = ''..string.sub(this.Text, 1, cursorPosition - 1)..string.sub(this.Text, cursorPosition + 1, string.len(this.Text));
			cursorPosition = cursorPosition - 1;
		end
	end

	local processDeleteKey = function()
		if (string.len(this.Text) > cursorPosition) then
			this.Text = ''..string.sub(this.Text, 1, cursorPosition)..string.sub(this.Text, cursorPosition + 2, string.len(this.Text));
		end
	end

	this.ProcessKeyEvent = function(_, key)
		if (focus) then
			local keyName = keys.getName(key);
			if (keyName == 'backspace') then
				processBackspaceKey();
			elseif (keyName == 'delete') then
				processDeleteKey();
			elseif (keyName == 'right') then
				if (cursorPosition < string.len(this.Text)) then
					cursorPosition = cursorPosition + 1;
				end
			elseif (keyName == 'left') then
				if (cursorPosition > 0) then
					cursorPosition = cursorPosition - 1;
				end
			elseif (keyName == 'home') then
				cursorPosition = 0;
			elseif (keyName == 'end') then
				cursorPosition = string.len(this.Text);
			end
		end
	end

	this.ProcessCharEvent = function(_, char)
		if (focus) then
			local textBefore = ''..string.sub(this.Text, 1, cursorPosition);
			local textAfter = ''..string.sub(this.Text, cursorPosition + 1, string.len(this.Text));
			this.Text = textBefore..char..textAfter;
			cursorPosition = cursorPosition + 1;
		end
	end

	this.SetFocus = function(_, newFocus)
		focus = newFocus;
	end
end)
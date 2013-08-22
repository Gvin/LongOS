Classes.Components.PopupMenu = Class(Object, function(this, x, y, width, height, backgroundColor, _allowAutoHeight)
	Object.init(this, 'PopupMenu');


	this.X = x;
	this.Y = y;
	this.Width = width;
	this.Height = height;
	this.BackgroundColor = backgroundColor;

	local isOpened = false;
	local componentsManager = Classes.Application.ComponentsManager();
	local allowAutoHeight = _allowAutoHeight;
	if (allowAutoHeight == nil) then
		allowAutoHeight = false;
	end

	this.AddComponent = function(_, component)
		componentsManager:AddComponent(component);
	end

	function this:Clear()
		this.Height = 1;
		componentsManager:Clear();	
	end

	this.GetIsOpened = function(_)
		return isOpened;
	end

	this.Contains = function(_, x, y)
		return (x >= this.X and x <= this.X + this.Width - 1 and y >= this.Y and y <= this.Y + this.Height - 1);
	end

	this.Open = function(_)
		isOpened = true;
	end

	this.Close = function(_)
		isOpened = false;
	end

	this.OpenClose = function(_)
		isOpened = not isOpened;
	end

	local drawComponents = function(videoBuffer)
		componentsManager:Draw(videoBuffer, this.X, this.Y, this.Width, this.Height);
	end

	local drawFrame = function(videoBuffer)
		videoBuffer:SetTextColor(colors.gray);
		videoBuffer:SetBackgroundColor(this.BackgroundColor);
		videoBuffer:WriteAt(this.X, this.Y, '+');
		videoBuffer:WriteAt(this.X + this.Width - 1, this.Y, '+');
		videoBuffer:WriteAt(this.X,  this.Y + this.Height - 1, '+');
		videoBuffer:WriteAt(this.X + this.Width - 1,  this.Y + this.Height - 1, '+');
		for i = this.X + 1, this.Width + this.X - 2 do
			videoBuffer:WriteAt(i, this.Y, '-');
			videoBuffer:WriteAt(i, this.Y + this.Height - 1, '-');
		end
		for i = this.Y + 1, this.Height + this.Y - 2 do
			videoBuffer:WriteAt(this.X, i, '|')
			for j = this.X + 1, this.Width + this.X - 2 do
				videoBuffer:WriteAt(j, i, ' ');
			end
			videoBuffer:WriteAt(this.X + this.Width - 1, i, '|')
		end
	end

	local updateHeight = function()
		if (allowAutoHeight) then
			local height = 2;
			for i = 1, componentsManager:GetComponentsCount() do
				if (componentsManager:GetComponent(i):GetY() - this.Y > height) then
					height = componentsManager:GetComponent(i):GetY() - this.Y + 2;
				end
			end

			this.Height = height;
		end
	end

	local updateWidth = function()
		local width = 0;
		for i = 1, componentsManager:GetComponentsCount() do
			if (string.len(componentsManager:GetComponent(i):GetText()) > width) then
				width = string.len(componentsManager:GetComponent(i):GetText());
			end
		end

		this.Width = width + 2;
	end

	this.Draw = function(_, videoBuffer)
		if (backgroundColor == nil) then
			local colorConfiguration = System:GetColorConfiguration();
			this.BackgroundColor = colorConfiguration:GetColor('WindowColor');
		end

		updateWidth();
		updateHeight();

		if (isOpened) then
			drawFrame(videoBuffer);
			drawComponents(videoBuffer);
		end
	end

	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		if (not isOpened) then
			return false;
		end
		if (this:Contains(cursorX, cursorY)) then
			if (componentsManager:ProcessLeftClickEvent(cursorX, cursorY)) then
				this:Close();
			end
			return true;
		else
			this:Close();
		end
		return false;
	end
end)
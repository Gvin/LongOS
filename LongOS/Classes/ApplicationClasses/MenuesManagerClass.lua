-- Menues manager manages all menues of the owner.
-- It takes care abount opening and closing menues,
-- drawing them to the buffer and events processing.
MenuesManager = Class(function(this)
	local menues = {};

	-- Add new menu to the collection.
	this.AddMenu = function(_, name, menu)
		menues[name] = menu;
	end

	-- Close all menues.
	this.CloseAll = function(_)
		for key, v in pairs(menues) do
			menues[key]:Close();
		end
	end

	-- Open selected menu and close the others.
	this.OpenMenu = function(_, name)
		this:CloseAll();
		menues[name]:Open();
	end

	-- Open selected menu if it is closed and close if it is opened.
	-- This operation also closes all other menues.
	this.OpenCloseMenu = function(_, name)
		local wasOpened = menues[name]:GetIsOpened();
		this:CloseAll();
		if (not wasOpened) then
			menues[name]:Open();
		end
	end

	-- Process left click event.
	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		for key, v in pairs(menues) do
			if (menues[key]:ProcessLeftClickEvent(cursorX, cursorY)) then
				return true;
			end
		end
		return false;
	end

	-- Draw all menues to the buffer.
	this.Draw = function(_, videoBuffer)
		local colorConfiguration = System:GetColorConfiguration();
		for key, v in pairs(menues) do
			menues[key].BackgroundColor = colorConfiguration:GetColor('WindowColor');
			menues[key]:Draw(videoBuffer);
		end
	end

	-- Get the count of all menues.
	this.GetMenuesCount = function(_)
		return #menues;
	end

	-- Get menu instance by it's name.
	this.GetMenue = function(_, name)
		return menues[name];
	end

	-- Execute specified operation for each menu in the collection.
	this.ForEach = function(_, operation)
		for key, v in pairs(menues) do
			operation(menues[key]);
		end
	end

	this.Contains = function(_, x, y)
		for key, v in pairs(menues) do
			if (menues[key]:GetIsOpened() and menues[key]:Contains(x, y)) then
				return true;
			end
		end
		return false;
	end
end)
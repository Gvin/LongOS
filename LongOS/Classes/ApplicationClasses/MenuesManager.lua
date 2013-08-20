-- Menues manager manages all menues of the owner.
-- It takes care abount opening and closing menues,
-- drawing them to the buffer and events processing.
MenuesManager = Class(Object, function(this)
	Object.init(this, 'MenuesManager');

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local menues;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:AddMenu(name, menu)
		menues[name] = menu;
	end

	function this:CloseAll()
		for key, v in pairs(menues) do
			menues[key]:Close();
		end
	end

	function this:OpenMenu(name)
		this:CloseAll();
		menues[name]:Open();
	end

	function this:OpenCloseMenu(name)
		local wasOpened = menues[name]:GetIsOpened();
		this:CloseAll();
		if (not wasOpened) then
			menues[name]:Open();
		end
	end

	function this:ProcessLeftClickEvent(cursorX, cursorY)
		for key, v in pairs(menues) do
			if (menues[key]:ProcessLeftClickEvent(cursorX, cursorY)) then
				return true;
			end
		end
		return false;
	end

	function this:Draw(videoBuffer)
		local colorConfiguration = System:GetColorConfiguration();
		for key, v in pairs(menues) do
			menues[key].BackgroundColor = colorConfiguration:GetColor('WindowColor');
			menues[key]:Draw(videoBuffer);
		end
	end

	function this:GetMenuesCount()
		return #menues;
	end

	function this:GetMenu(name)
		return menues[name];
	end

	function this:ForEach(operation)
		for key, v in pairs(menues) do
			operation(menues[key]);
		end
	end

	function this:Contains(x, y)
		for key, v in pairs(menues) do
			if (menues[key]:GetIsOpened() and menues[key]:Contains(x, y)) then
				return true;
			end
		end
		return false;
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor()
		menues = {};
	end

	constructor();
end)
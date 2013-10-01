-- Menues manager manages all menues of the owner.
-- It takes care abount opening and closing menues,
-- drawing them to the buffer and events processing.
Classes.Application.MenuesManager = Class(Object, function(this)
	Object.init(this, 'MenuesManager');

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local menues;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:AddMenu(_name, _menu)
		menues[_name] = _menu;
	end

	function this:CloseAll()
		for key, v in pairs(menues) do
			menues[key]:Close();
		end
	end

	function this:OpenMenu(_name)
		this:CloseAll();
		menues[_name]:Open();
	end

	function this:OpenCloseMenu(_name)
		local wasOpened = menues[_name]:GetIsOpened();
		this:CloseAll();
		if (not wasOpened) then
			menues[_name]:Open();
		end
	end

	function this:ProcessLeftClickEvent(_cursorX, _cursorY)
		for key, v in pairs(menues) do
			if (menues[key]:ProcessLeftClickEvent(_cursorX, _cursorY)) then
				return true;
			end
		end
		return false;
	end

	function this:Draw(_videoBuffer)
		local colorConfiguration = System:GetColorConfiguration();
		for key, v in pairs(menues) do
			menues[key].BackgroundColor = colorConfiguration:GetColor('WindowColor');
			menues[key]:Draw(_videoBuffer);
		end
	end

	function this:GetMenuesCount()
		return #menues;
	end

	function this:GetMenu(_name)
		return menues[_name];
	end

	function this:ForEach(_operation)
		for key, v in pairs(menues) do
			_operation(menues[key]);
		end
	end

	function this:Contains(_x, _y)
		for key, v in pairs(menues) do
			if (menues[key]:GetIsOpened() and menues[key]:Contains(_x, _y)) then
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
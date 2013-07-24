Desktop = Class(function(this)
	this.GetClassName = function()
		return "Desktop";
	end

	----- FIELDS -----

	local wallpaper;
	local desktopMenu;

	----- METHODS -----

	this.LoadWallpaper = function(_, _fileName)
		wallpaper = Image(_fileName);
	end

	this.Draw = function(_, videoBuffer)
		for i = 1, wallpaper:GetHeight() do
			for j = 1, wallpaper:GetWidth() do
				local color = wallpaper:GetPixel(j, i);
				videoBuffer:SetPixelColor(j, i, color);
			end
		end

		desktopMenu:Draw(videoBuffer);
	end

	this.ProcessRightClickEvent = function(_, cursorX, cursorY)
		desktopMenu.X = cursorX;
		desktopMenu.Y = cursorY;
		desktopMenu:Open();
	end

	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		desktopMenu:ProcessLeftClickEvent(cursorX, cursorY);
		desktopMenu:Close();
	end

	----- CONSTRUCTORS -----

	local constructor = function()
		desktopMenu = PopupMenu(1, 1, 18, 3, nil);

		local changeWallpaperButton = Button('Change wallpaper', colors.gray, colors.white, 1, 1, 'left-top');
		desktopMenu:AddComponent(changeWallpaperButton);
	end

	constructor();
end)
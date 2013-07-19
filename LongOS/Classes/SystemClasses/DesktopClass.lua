Desktop = Class(function(a)
	local wallpaper = {};
	local wallpaperWidth = 51;
	local wallpaperHeight = 19;
	a.FileName = '';

	local desktopMenu = PopupMenu(1, 1, 18, 3, colors.lightGray);

	local changeWallpaperButton = Button('Change wallpaper', colors.gray, colors.white, 1, 1, 'left-top');
	desktopMenu:AddComponent(changeWallpaperButton);

	local loadWallpaper = function(wallpaperName)
		a.FileName = wallpaperName;
		local wallpaper = {};
		local file = fs.open(wallpaperName, 'r');
		local size = stringExtAPI.separate(file.readLine(),'x');
		wallpaperWidth = size[1];
		wallpaperHeight = size[2];
		for i = 1, wallpaperHeight do
			local line = file.readLine();
			wallpaper[i] = stringExtAPI.separate(line, ' ');
			for j = 1, wallpaperWidth do
				wallpaper[i][j] = wallpaper[i][j] + 0;
			end
		end
		file.close();

		return wallpaper;
	end

	a.LoadWallpaper = function(_, wallpaperName)
		wallpaper = loadWallpaper(wallpaperName);
	end

	a.Draw = function(_, videoBuffer)
		for i = 1, wallpaperHeight do
			for j = 1, wallpaperWidth do
				local color = wallpaper[i][j];
				videoBuffer:SetPixelColor(j, i, color);
			end
		end
		local colorConfiguration = System:GetColorConfiguration();
		desktopMenu.BackgroundColor = colorConfiguration:GetColor('WindowColor');
		desktopMenu:Draw(videoBuffer);
	end

	a.ProcessRightClickEvent = function(_, cursorX, cursorY)
		desktopMenu.X = cursorX;
		desktopMenu.Y = cursorY;
		desktopMenu:Open();
	end

	a.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		desktopMenu:ProcessLeftClickEvent(cursorX, cursorY);
		desktopMenu:Close();
	end
end)
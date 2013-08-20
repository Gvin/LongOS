local Image = Classes.System.Graphics.Image;
local Button = Classes.Components.Button;
local PopupMenu = Classes.Components.PopupMenu;


Desktop = Class(Object, function(this)
	Object.init(this, 'Desktop');

	----- FIELDS -----

	local wallpaper;
	local desktopMenu;
	local changeWallpaperButton;

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

		local configuration = System:GetColorConfiguration();
		changeWallpaperButton:SetBackgroundColor(configuration:GetColor('SystemButtonsColor'))
		changeWallpaperButton:SetTextColor(configuration:GetColor('SystemButtonsTextColor'));

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

	local function changeWallpaperButtonClick(_sender, _eventArgs)
		System:RunFile('/LongOS/SystemUtilities/WallpaperManager/WallpaperManager.exec');
	end

	----- CONSTRUCTORS -----

	local constructor = function()
		desktopMenu = PopupMenu(1, 1, 18, 3, nil);

		changeWallpaperButton = Button('Change wallpaper', colors.gray, colors.black, 1, 1, 'left-top');
		changeWallpaperButton:AddOnClickEventHandler(changeWallpaperButtonClick);
		desktopMenu:AddComponent(changeWallpaperButton);
	end

	constructor();
end)
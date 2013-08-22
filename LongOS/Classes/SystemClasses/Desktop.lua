local Image = Classes.System.Graphics.Image;
local Button = Classes.Components.Button;
local PopupMenu = Classes.Components.PopupMenu;


Classes.System.Desktop = Class(Object, function(this)
	Object.init(this, 'Desktop');

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local wallpaper;
	local desktopMenu;
	local changeWallpaperButton;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:LoadWallpaper(_fileName)
		wallpaper = Image(_fileName);
	end

	function this:Draw(_videoBuffer)
		for i = 1, wallpaper:GetHeight() do
			for j = 1, wallpaper:GetWidth() do
				local color = wallpaper:GetPixel(j, i);
				_videoBuffer:SetPixelColor(j, i, color);
			end
		end

		local configuration = System:GetColorConfiguration();
		changeWallpaperButton:SetBackgroundColor(configuration:GetColor('SystemButtonsColor'))
		changeWallpaperButton:SetTextColor(configuration:GetColor('SystemButtonsTextColor'));

		desktopMenu:Draw(_videoBuffer);
	end

	function this:ProcessRightClickEvent(_cursorX, _cursorY)
		desktopMenu.X = _cursorX;
		desktopMenu.Y = _cursorY;
		desktopMenu:Open();
	end

	function this:ProcessLeftClickEvent(_cursorX, _cursorY)
		desktopMenu:ProcessLeftClickEvent(_cursorX, _cursorY);
		desktopMenu:Close();
	end

	local function changeWallpaperButtonClick(_sender, _eventArgs)
		System:RunFile('/LongOS/SystemUtilities/WallpaperManager/WallpaperManager.exec');
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor()
		desktopMenu = PopupMenu(1, 1, 18, 3, nil);

		changeWallpaperButton = Button('Change wallpaper', colors.gray, colors.black, 1, 1, 'left-top');
		changeWallpaperButton:AddOnClickEventHandler(changeWallpaperButtonClick);
		desktopMenu:AddComponent(changeWallpaperButton);
	end

	constructor();
end)
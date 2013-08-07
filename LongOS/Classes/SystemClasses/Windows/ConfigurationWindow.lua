ConfigurationWindow = Class(Window, function(this, _application)
	Window.init(this, _application, 'Configuration window', false);
	this:SetTitle('Configuration');
	this:SetX(10);
	this:SetY(3);
	this:SetWidth(30);
	this:SetHeight(10);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);

	local colorConfigurationButtonClick = function(_sender, _eventArgs)
		local colorWindow = ColorConfigurationWindow(_application);
		colorWindow:Show();
		this:Close();
	end

	local colorConfigurationButton = Button('Open color configuration', nil, nil, 0, 1, 'left-top');
	colorConfigurationButton:SetOnClick(EventHandler(colorConfigurationButtonClick));
	this:AddComponent(colorConfigurationButton);
end)
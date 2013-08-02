ConfigurationWindow = Class(Window, function(this, _application)
	Window.init(this, _application, 'Configuration window', false, false, 'Configuration', 10, 3, 30, 10, nil, false, true);

	local colorConfigurationButtonClick = function(_sender, _eventArgs)
		local colorWindow = ColorConfigurationWindow(_application);
		colorWindow:Show();
		this:Close();
	end

	local colorConfigurationButton = Button('Open color configuration', nil, nil, 1, 2, 'left-top');
	colorConfigurationButton:SetOnClick(EventHandler(colorConfigurationButtonClick));
	this:AddComponent(colorConfigurationButton);
end)
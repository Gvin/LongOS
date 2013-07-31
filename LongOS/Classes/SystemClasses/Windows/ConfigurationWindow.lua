ConfigurationWindow = Class(Window, function(this, application)
	Window.init(this, application, 10, 3, 30, 10, false, true, nil, 'Configuration window', 'Configuration', true);

	local colorConfigurationButtonClick = function(sender, eventArgs)
		local colorWindow = ColorConfigurationWindow(application);
		colorWindow:Show();
		this:Close();
	end

	local colorConfigurationButton = Button('Open color configuration', nil, nil, 1, 2, 'left-top');
	colorConfigurationButton:SetOnClick(EventHandler(colorConfigurationButtonClick));
	this:AddComponent(colorConfigurationButton);
end)
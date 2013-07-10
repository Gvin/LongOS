local function colorConfigurationButtonClick(params)
	local colorWindow = ColorConfigurationWindow(params[1]);
	colorWindow:Show();
	params[2]:Close();
end

ConfigurationWindow = Class(Window, function(this, application)
	Window.init(this, application, 10, 3, 30, 10, false, true, nil, 'Configuration window', 'Configuration', true);

	local colorConfigurationButton = Button('Open color configuration', nil, nil, 1, 2, 'left-top');
	colorConfigurationButton.OnClick = colorConfigurationButtonClick;
	colorConfigurationButton.OnClickParams = { application, this };
	this:AddComponent(colorConfigurationButton);
end)
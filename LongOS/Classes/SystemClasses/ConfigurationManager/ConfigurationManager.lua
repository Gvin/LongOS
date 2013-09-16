-- Cjnfiguration manager class for storing and managing configuration acess.
Classes.System.Configuration.ConfigurationManager = Class(Object, function(this)
	Object.init(this, 'ConfigurationManager');

	local colorConfiguration = Classes.System.Configuration.ColorConfiguration('/LongOS/Configuration/color_schema.xml');
	local interfaceConfiguration = Classes.System.Configuration.InterfaceConfiguration('/LongOS/Configuration/interface_configuration.xml');
	local mouseConfiguration = Classes.System.Configuration.MouseConfiguration('/LongOS/Configuration/mouse_configuration.xml');
	local applicationsConfiguration = Classes.System.Configuration.ApplicationsConfiguration('/LongOS/Configuration/applications_configuration.xml');
	local fileAssotiationsConfiguration = Classes.System.Configuration.FileAssotiationsConfiguration('/LongOS/Configuration/file_assotiations_configuration.xml');
	-- Gets color configuration.
	this.GetColorConfiguration = function()
		return colorConfiguration;
	end

	-- Gets intreface configuration.
	this.GetInterfaceConfiguration = function()
		return interfaceConfiguration;
	end

	-- Gets mouse configuration.
	this.GetMouseConfiguration = function()
		return mouseConfiguration;
	end
	
	-- Gets application configuration.
	this.GetApplicationsConfiguration = function()
		return applicationsConfiguration;
	end

	function this:GetFileAssotiationsConfiguration()
		return fileAssotiationsConfiguration;
	end

	-- Reads all configurations.
	this.ReadConfiguration = function()
		colorConfiguration:ReadConfiguration();
		interfaceConfiguration:ReadConfiguration();
		mouseConfiguration:ReadConfiguration();
		applicationsConfiguration:ReadConfiguration();
		fileAssotiationsConfiguration:ReadConfiguration();
	end

	-- Writes all configurations.
	this.WriteConfiguration = function()
		colorConfiguration:WriteConfiguration();
		interfaceConfiguration:WriteConfiguration();
		mouseConfiguration:WriteConfiguration();
		applicationsConfiguration:WriteConfiguration();
	end
end)
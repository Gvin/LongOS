-- Cjnfiguration manager class for storing and managing configuration acess.
ConfigurationManager = Class(function(this)

	this.GetClassName = function()
		return 'ConfigurationManager';
	end

	local colorConfiguration = ColorConfiguration('/LongOS/Configuration/color_schema.xml');
	local interfaceConfiguration = InterfaceConfiguration('/LongOS/Configuration/interface_configuration.xml');
	local mouseConfiguration = MouseConfiguration('/LongOS/Configuration/mouse_configuration.xml');
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

	-- Reads all configurations.
	this.ReadConfiguration = function()
		colorConfiguration:ReadConfiguration();
		interfaceConfiguration:ReadConfiguration();
		mouseConfiguration:ReadConfiguration();
	end

	-- Writes all configurations.
	this.WriteConfiguration = function()
		colorConfiguration:WriteConfiguration();
		interfaceConfiguration:WriteConfiguration();
		mouseConfiguration:WriteConfiguration();
	end
end)
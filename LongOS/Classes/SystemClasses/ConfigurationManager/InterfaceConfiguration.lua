-- Configuration class for interface modification support.
InterfaceConfiguration = Class(function(this, _fileName)

	this.GetClassName = function()
		return 'InterfaceConfiguration';
	end

	if (type(_fileName) ~= 'string') then
		error('InterfaceConfiguration.Constructor [fileName]: string expected, got '..type(_fileName)..'.');
	end

	local fileName = _fileName;
	local data = nil;

	local function getData(parsed)
		local usefulData = {};
		for i = 1, #parsed[1] do
			local info = parsed[1][i].xarg;
			usefulData[info.name] = info.value;
		end
		return usefulData;
	end

	-- Read interface configuration from the disk.
	this.ReadConfiguration = function()
		if (not fs.exists(fileName)) then
			error('InterfaceConfiguration.ReadConfiguration: configuration file '..fileName.." doesn't exists on the disk.");
		end

		local file = fs.open(fileName, 'r');
		local text = file.readAll();
		file.close();

		local parsed = xmlAPI.parse(text);

		data = getData(parsed);
	end

	-- Get option from the configuration by it's name.
	this.GetOption = function(_, optionName)
		if (type(optionName) ~= 'string') then
			error('InterfaceConfiguration.GetValue [optionName]: string expected, got '..type(optionName)..'.');
		end
		if (data == nil) then
			error('InterfaceConfiguration.GetValue: configuration must be red first. Use ReadConfiguration method.');
		end

		return data[optionName];
	end

	-- Set option from the configuration by it's name.
	this.SetOption = function(_, optionName, value)
		if (type(optionName) ~= 'string') then
			error('InterfaceConfiguration.SetOption [optionName]: string expected, got '..type(optionName)..'.');
		end
		if (type(value) ~= 'string') then
			error('InterfaceConfiguration.SetOption [value]: string expected, got '..type(value)..'.');
		end
		if (data == nil) then
			error('InterfaceConfiguration.SetOption: configuration must be red first. Use ReadConfiguration method.');
		end
		if (data[optionName] == nil) then
			error('InterfaceConfiguration.SetOption [optionName]: option not found in configuration.');
		end

		data[optionName] = value;
	end

	local function prepareDocument()
		local document = {};
		document['label'] = 'configurations';
		for key, _ in pairs(data) do
			local subnode = {};
			subnode['label'] = 'configuration';
			subnode['xarg'] = {};
			subnode.xarg['name'] = key;
			subnode.xarg['value'] = ''..data[key];
			table.insert(document, subnode);
		end
		return document;
	end

	-- Write configuration back to the disk.
	this.WriteConfiguration = function()
		if (data == nil) then
			error('InterfaceConfiguration.WriteConfiguration: configuration must be red first. Use ReadConfiguration method.');
		end

		local document = prepareDocument();
		xmlAPI.write(document, fileName);
	end
end)
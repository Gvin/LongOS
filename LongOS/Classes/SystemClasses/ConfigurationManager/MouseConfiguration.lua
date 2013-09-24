-- Configuration class for mouse modification support.
Classes.System.Configuration.MouseConfiguration = Class(Object, function(this, _fileName)
	Object.init(this, 'MouseConfiguration');

	if (type(_fileName) ~= 'string') then
		error('MouseConfiguration.Constructor [fileName]: string expected, got '..type(_fileName)..'.');
	end

	local fileName = _fileName;
	local data = nil;
	local defaultData = { 
						DoubleClickSpeed ="5"	
					};

	function this:SetDefault()
		data = {};
		for key,value in pairs(defaultData) do
			data[key] = value;
		end
		this:WriteConfiguration();
	end

	local function checkData()
		local rewrite = false;
		for key,value in pairs(defaultData) do
			if (data[key] == nil) then
				rewrite = true;
				data[key] = value;
				System:LogWarningMessage('Field "'..key..'" was not found in the configuration file "'..fileName..'". The default value was written.');
			end			
		end 
		if (rewrite == true) then
			this:WriteConfiguration();
		end
	end

	local function getData(parsed)
		local usefulData = {};
		for i = 1, #parsed[1] do
			local info = parsed[1][i].xarg;
			usefulData[info.name] = info.value;
		end
		return usefulData;
	end

	local fun


	-- Read mouse configuration from the disk.
	function this:ReadConfiguration()
		if (not fs.exists(fileName)) then
			System:LogWarningMessage('Configuration file "'..fileName..'" not found. Default configuration file was created.');
			this:SetDefault();
			return;
		end
		local file = fs.open(fileName, 'r');
		local text = file.readAll();
		file.close();
		local sucess, parsed = pcall( xmlAPI.parse,text);
		if (not sucess) then			
			System:LogWarningMessage('Configuration file "'..fileName..'" is damaged and cannot be read. Replaced with a default configuration file.');
			this:SetDefault();
			return;			
		end		
		local sucess, preparedData = pcall(getData,parsed);
		if (not sucess) then			
			System:LogWarningMessage('Configuration file "'..fileName..'" is damaged and cannot be read. Replaced with a default configuration file.');
			this:SetDefault();
			return;			
		end		
		data = preparedData;
		checkData();
	end

	-- Get option from the configuration by it's name.
	function this:GetOption(optionName)
		if (type(optionName) ~= 'string') then
			error('MouseConfiguration.GetValue [optionName]: string expected, got '..type(optionName)..'.');
		end
		if (data == nil) then
			error('MouseConfiguration.GetValue: configuration must be red first. Use ReadConfiguration method.');
		end

		return data[optionName];
	end

	-- Set option from the configuration by it's name.
	function this:SetOption(optionName, value)
		if (type(optionName) ~= 'string') then
			error('MouseConfiguration.SetOption [optionName]: string expected, got '..type(optionName)..'.');
		end
		if (type(value) ~= 'string') then
			error('MouseConfiguration.SetOption [value]: string expected, got '..type(value)..'.');
		end
		if (data == nil) then
			error('MouseConfiguration.SetOption: configuration must be red first. Use ReadConfiguration method.');
		end
		if (data[optionName] == nil) then
			error('MouseConfiguration.SetOption [optionName]: option not found in configuration.');
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
	function this:WriteConfiguration()
		if (data == nil) then
			error('MouseConfiguration.WriteConfiguration: configuration must be red first. Use ReadConfiguration method.');
		end

		local document = prepareDocument();
		xmlAPI.write(document, fileName);
	end
end)
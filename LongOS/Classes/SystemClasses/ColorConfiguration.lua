-- Configuration class for color schema support.
ColorConfiguration = Class(function(this, _fileName)
	if (type(_fileName) ~= 'string') then
		error('ColorConfiguration.Constructor [fileName]: string expected, got '..type(_fileName)..'.');
	end

	local fileName = _fileName;
	local data = nil;

	local function getData(parsed)
		local usefulData = {};
		for i = 1, #parsed[1] do
			local info = parsed[1][i].xarg;
			usefulData[info.name] = info.value + 0;
		end
		return usefulData;
	end

	-- Read color configuration from the disk.
	this.ReadConfiguration = function()
		if (not fs.exists(fileName)) then
			error('ColorConfiguration.ReadConfiguration: configuration file '..fileName.." doesn't exists on the disk.");
		end

		local file = fs.open(fileName, 'r');
		local text = file.readAll();
		file.close();

		local parsed = xmlAPI.parse(text);

		data = getData(parsed);
	end

	-- Get color from the configuration by it's name.
	this.GetColor = function(_, colorName)
		if (type(colorName) ~= 'string') then
			error('ColorConfiguration.GetColor [colorName]: string expected, got '..type(colorName)..'.');
		end
		if (data == nil) then
			error('ColorConfiguration.GetColor: configuration must be red first. Use ReadConfiguration method.');
		end

		return data[colorName];
	end

	-- Set color from the configuration by it's name.
	this.SetColor = function(_, colorName, value)
		if (type(colorName) ~= 'string') then
			error('ColorConfiguration.SetColor [colorName]: string expected, got '..type(colorName)..'.');
		end
		if (type(value) ~= 'number') then
			error('ColorConfiguration.SetColor [value]: int expected, got '..type(value)..'.');
		end
		if (data == nil) then
			error('ColorConfiguration.GetColor: configuration must be red first. Use ReadConfiguration method.');
		end
		if (data[colorName] == nil) then
			error('ColorConfiguration.SetColor [colorName]: color not found in configuration.');
		end

		data[colorName] = value;
	end

	local function prepareDocument()
		local document = {};
		document['label'] = 'color-schemas';
		for key, _ in pairs(data) do
			local subnode = {};
			subnode['label'] = 'schema';
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
			error('ColorConfiguration.WriteConfiguration: configuration must be red first. Use ReadConfiguration method.');
		end

		local document = prepareDocument();
		xmlAPI.write(document, fileName);
	end
end)
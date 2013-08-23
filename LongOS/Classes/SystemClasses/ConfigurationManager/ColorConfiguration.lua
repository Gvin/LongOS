-- Configuration class for color schema support.
Classes.System.Configuration.ColorConfiguration = Class(Object, function(this, _fileName)
	Object.init(this, 'ColorConfiguration');

	if (type(_fileName) ~= 'string') then
		error('ColorConfiguration.Constructor [fileName]: string expected, got '..type(_fileName)..'.');
	end

	local fileName = _fileName;
	local data = nil;

	function this:GetData()		
		return data;
	end

	local function prepareData(parsed)
		local usefulData = {};
		for i = 1, #parsed[1] do
			local info = parsed[1][i].xarg;
			usefulData[info.name] = info.value + 0;
		end
		return usefulData;
	end

	-- Read color configuration from the disk.
	function this:ReadConfiguration()
		if (not fs.exists(fileName)) then
			error('ColorConfiguration.ReadConfiguration: configuration file '..fileName.." doesn't exists on the disk.");
		end

		local file = fs.open(fileName, 'r');
		local text = file.readAll();
		file.close();

		local parsed = xmlAPI.parse(text);

		data = prepareData(parsed);
	end

	-- Get color from the configuration by it's name.
	function this:GetColor(_colorName)
		if (type(_colorName) ~= 'string') then
			error('ColorConfiguration.GetColor [colorName]: string expected, got '..type(_colorName)..'.');
		end
		if (data == nil) then
			error('ColorConfiguration.GetColor: configuration must be red first. Use ReadConfiguration method.');
		end

		return data[_colorName];
	end

	-- Set color from the configuration by it's name.
	function this:SetColor(_colorName, _value)
		if (type(_colorName) ~= 'string') then
			error('ColorConfiguration.SetColor [colorName]: string expected, got '..type(_colorName)..'.');
		end
		if (type(_value) ~= 'number') then
			error('ColorConfiguration.SetColor [value]: number expected, got '..type(_value)..'.');
		end
		if (data == nil) then
			error('ColorConfiguration.SetColor: configuration must be red first. Use ReadConfiguration method.');
		end
		if (data[_colorName] == nil) then
			error('ColorConfiguration.SetColor [colorName]: color not found in configuration.');
		end

		data[_colorName] = _value;
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
	function this:WriteConfiguration()
		if (data == nil) then
			error('ColorConfiguration.WriteConfiguration: configuration must be red first. Use ReadConfiguration method.');
		end
		local document = prepareDocument();
		xmlAPI.write(document, fileName);
	end
end)
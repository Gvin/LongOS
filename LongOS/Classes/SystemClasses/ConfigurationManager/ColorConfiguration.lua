-- Configuration class for color schema support.
Classes.System.Configuration.ColorConfiguration = Class(Object, function(this, _fileName)
	Object.init(this, 'ColorConfiguration');

	if (type(_fileName) ~= 'string') then
		error('ColorConfiguration.Constructor [fileName]: string expected, got '..type(_fileName)..'.');
	end

	local fileName = _fileName;
	local data = nil;
	local defaultData = { 
						ProgressBarEmptyColor=16384,
						ProgressBarFilledColor=32,
						SelectedBackgroundColor=8,
						TopLineTextColor=1,
						TimeTextColor=1,
						TopLineInactiveColor=128,
						SelectedTextColor=1,
						ControlPanelButtonsColor=32,
						SystemButtonsColor=128,
						WindowBorderColor=32768,
						SystemEditsBackgroundColor=1,
						WindowColor=256,
						TopLineActiveColor=32768,
						DesktopBackgroundColor=16384,
						ControlPanelPowerButtonColor=16384,
						SystemButtonsTextColor=1,
						SystemLabelsTextColor=32768,
						ControlPanelColor=8192
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
			if (data[key] == nil ) then
				rewrite = true;
				data[key] = value;
				System:LogWarningMessage('Field "'..key..'" was not found in the configuration file "'..fileName..'". The default value was written.');
			end			
		end 
		if (rewrite == true) then
			this:WriteConfiguration();
		end
	end

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
			System:LogWarningMessage('Configuration file "'..fileName..'" not found. Default configuration file was created.');
			this:SetDefault();
			return;
		end
		local file = fs.open(fileName, 'r');
		local text = file.readAll();
		file.close();

		local sucess, parsed = pcall( xmlAPI.parse,text);
		if (not sucess) then
			if (parsed == nil) then
				parsed = 'No message.';
			end
			System:LogWarningMessage('Configuration file "'..fileName..'" is damaged and cannot be read. Replaced with a default configuration file.');
			this:SetDefault();
			return;			
		end		
		local sucess, preparedData = pcall(prepareData,parsed);
		if (not sucess) then
			if (preparedData == nil) then
				preparedData = 'No message.';
			end
			System:LogWarningMessage('Configuration file "'..fileName..'" is damaged and cannot be read. Replaced with a default configuration file.');
			this:SetDefault();
			return;			
		end		
		data = preparedData;
		checkData();
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
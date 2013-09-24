-- Configuration class for application modification support.
Classes.System.Configuration.ApplicationsConfiguration = Class(Object,function(this, _fileName)

	function this:GetClassName()
		return 'ApplicationsConfiguration';
	end

	if (type(_fileName) ~= 'string') then
		error('ApplicationsConfiguration.Constructor [fileName]: string expected, got '..type(_fileName)..'.');
	end

	local fileName = _fileName;
	local data = nil;
	local defaultData = { 
						{" Calculator ","%SYSDIR%/Utilities/Calculator/GvinCalculator.exec","false"},
						{" BiriPaint  ","%SYSDIR%/Utilities/BiriPaint/BiriPaint.exec","false"},
						{"File manager","%SYSDIR%/Utilities/FileManager/GvinFileManager.exec","false"},
						{"    Worm    ","worm","true"},
						{"    Lua     ","lua","true"}
					};

	function this:SetDefault()
		data = {};
		for i=1,#defaultData do
			table.insert(data,defaultData[i]);
		end
		this:WriteConfiguration();
	end	

	local function prepareData(_parsed)
		local usefulData = {};
		for i = 1, #_parsed[1] do
			local app = {};
			local info = _parsed[1][i].xarg;
			table.insert(app,info.name);		
			table.insert(app,info.path);
			table.insert(app,info.terminal);	
			table.insert(usefulData,app);
		end			
		return usefulData;
	end

	-- Read application configuration from the disk.
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
	end

	-- Get configuration data.
	function this:GetApplicationsData()
		return data;
	end

	-- Set configuration data.
	function this:SetApplicationsData(_data)		
		data = _data;
	end	

	local function prepareDocument()
		local document = {};
		document['label'] = 'configurations';
		for i = 1, #data do
			local subnode = {};
			subnode['label'] = 'configuration';
			subnode['xarg'] = {};
			subnode.xarg['name'] = ''..data[i][1];	
			subnode.xarg['path'] = ''..data[i][2];		
			subnode.xarg['terminal'] = ''..data[i][3];			
			table.insert(document, subnode);
		end
		return document;
	end

	-- Write configuration back to the disk.
	function this:WriteConfiguration()
		if (data == nil) then
			error('ApplicationsConfiguration.WriteConfiguration: configuration must be red first. Use ReadConfiguration method.');
		end
		local document = prepareDocument();
		xmlAPI.write(document, fileName);
	end
end)
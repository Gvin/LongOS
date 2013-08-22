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
			error('ApplicationsConfiguration.ReadConfiguration: configuration file '..fileName.." doesn't exists on the disk.");
		end

		local file = fs.open(fileName, 'r');
		local text = file.readAll();
		file.close();
		local parsed = xmlAPI.parse(text);		
		data = prepareData(parsed);
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
Classes.System.Configuration.LocaleConfiguration = Class(Object, function(this, _filePath)
	Object.init(this, 'LocaleConfiguration');

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local filePath;
	local locale;
	local DEFAULT = 'en';

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:GetLocale()
		return locale;
	end

	function this:SetLocale(_value)
		if (type(_value) ~= 'string') then
			error('LocaleConfiguration.SetLocale [value]: String expected, got '..type(_value)..'.');
		end

		locale = _value;
	end

	function this:SetDefault()
		locale = DEFAULT;
		this:WriteConfiguration();
	end

	local function getData(_parsed)
		return _parsed[1][1];
	end

	local function checkData()
		if (locale == nil) then
			System:LogWarningMessage('Locale data was not found in the locale configuration file. Replaced with a default configuration file.');
			this:SetDefault();
		end
	end

	function this:ReadConfiguration()
		if (not fs.exists(filePath)) then
			System:LogWarningMessage('Configuration file "'..filePath..'" not found. Default configuration file was created.');
			this:SetDefault();
			return;
		end

		local file = fs.open(filePath, 'r');
		local text = file.readAll();
		file.close();

		local sucess, parsed = pcall(xmlAPI.parse, text);
		if (not sucess) then
			System:LogWarningMessage('Configuration file "'..fileName..'" is damaged and cannot be read. Replaced with a default configuration file.');
			this:SetDefault();
			return;			
		end		
		local sucess, preparedData = pcall(getData, parsed);
		if (not sucess) then
			System:LogWarningMessage('Configuration file "'..fileName..'" is damaged and cannot be read. Replaced with a default configuration file.');
			this:SetDefault();
			return;			
		end		
		locale = preparedData;
		checkData();
	end

	local function prepareDocument()
		local prepared = {};
		prepared.label = locale;
		table.insert(prepared, locale);
		return prepared;
	end

	function this:WriteConfiguration()
		local dicument = prepareDocument();
		xmlAPI.write(document, filePath);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor(_filePath)
		if (type(_filePath) ~= 'string') then
			error('LocaleConfiguration.Constructor [filePath]: String expected, got '..type(_filePath)..'.');
		end

		filePath = _filePath;
	end

	constructor(_filePath);
end)
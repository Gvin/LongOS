Classes.System.Localization.LocalizationManager = Class(Object, function(this, _localizationsDirectory, _defaultLocalizationFilePath)
	Object.init(this, 'LocalizationManager');

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local data;
	local default;
	local localizationsDirectory;
	local defaultLocalizationFilePath;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:GetLocalizedString(_key)
		if (data == nil and default == nil) then
			error('LocalizationManager.GetLocalizedString: No localization is loaded. Use ReadLocalization method to load.');
		end
		if (type(_key) ~= 'string') then
			error('LocalizationManager.GetLocalizedString [key]: String expected, got '..type(_key)..'.');
		end

		local value
		if (data ~= nil) then
			value = data[_key];
		end
		if (value == nil) then
			value = default[_key];
		end
		if (value == nil) then
			error('LocalizationManager.GetLocalizedString: Value not found for key "'..tostring(_key)..'".');
		end
		return value;
	end

	local function parseData(_xmlData)
		local result = {};
		for i = 1, #_xmlData[1] do
			local dataElement = _xmlData[1][i];
			if (dataElement.label ~= nil) then
				local value = ''..tostring(dataElement[1]);
				local key = dataElement.xarg.key;
				result[key] = value;
			end
		end
		return result;
	end

	local function readLocalization(_filePath)
		local file = fs.open(_filePath, 'r');
		local text = file.readAll();
		file.close();

		local sucess, parsed = pcall(xmlAPI.parse, text);
		if (not sucess) then
			error('LocalizationManager.ReadLocalization: Localization file "'.._filePath..'" is damaged and cannot be read.');		
		end	

		local sucess, preparedData = pcall(parseData, parsed);
		if (not sucess) then
			error('LocalizationManager.ReadLocalization: Localization file "'.._filePath..'" is damaged and cannot be read. Message: "'..tostring(preparedData)..'".');		
		end	

		return preparedData;
	end

	function this:ReadLocalization(_localizationCode)
		if (type(_localizationCode) ~= 'string') then
			error('LocalizationManager.ReadLocalization [localizationCode]: String expected, got '..type(_localizationCode)..'.');
		end

		local fileName = fs.combine(localizationsDirectory, _localizationCode..'.xml');

		if (not fs.exists(fileName) and not fs.exists(defaultLocalizationFilePath)) then
			error('LocalizationManager.ReadLocalization [localizationCode]: No localization file for localization code "'.._localizationCode..'".');
		end

		if (fs.exists(fileName)) then
			data = readLocalization(fileName);
		end
		default = readLocalization(defaultLocalizationFilePath);
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor(_localizationsDirectory, _defaultLocalizationFilePath)
		if (type(_localizationsDirectory) ~= 'string') then
			error('LocalizationManager.Constructor [localizationsDirectory]: String expected, got '..type(_localizationsDirectory)..'.');
		end
		if (not fs.isDir(_localizationsDirectory)) then
			error('LocalizationManager.Constructor [localizationsDirectory]: Directory path expected.');
		end
		if (type(_defaultLocalizationFilePath) ~= 'string') then
			error('LocalizationManager.Constructor [defaultLocalizationFilePath]: String expected, got '..type(_defaultLocalizationFilePath)..'.');
		end
		if (not fs.exists(_defaultLocalizationFilePath)) then
			error('LocalizationManager.Constructor [defaultLocalizationFilePath]: File path expected.');
		end

		localizationsDirectory = _localizationsDirectory;
		defaultLocalizationFilePath = _defaultLocalizationFilePath;
	end

	constructor(_localizationsDirectory, _defaultLocalizationFilePath);
end)
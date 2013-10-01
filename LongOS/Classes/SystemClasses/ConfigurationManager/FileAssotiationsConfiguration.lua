Classes.System.Configuration.FileAssotiationsConfiguration = Class(Object, function(this, _fileName)
	Object.init(this, 'FileAssotiationsConfiguration');

	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local fileName;
	local data;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	function this:ReadConfiguration()
		local file = fs.open(fileName, 'r');
		local text = file.readAll();
		file.close();

		local parsed = xmlAPI.parse(text);
		data = {};
		for i = 1, #parsed[1] do
			if (#parsed[1][i] > 0) then
				local assotiation = {};
				assotiation.Extension = parsed[1][i][1].xarg.value;
				assotiation.Application = parsed[1][i][2].xarg.value;
				assotiation.IconBackgroundColor = tonumber(parsed[1][i][3].xarg.value);
				assotiation.IconTextColor = tonumber(parsed[1][i][4].xarg.value);
				assotiation.IconSymbol = parsed[1][i][5].xarg.value;
				assotiation.FileNameColor = tonumber(parsed[1][i][6].xarg.value);
				data[assotiation.Extension] = assotiation;
			end
		end
	end

	function this:GetAssotiation(_extension)
		return data[_extension];
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constuctors ------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor(_fileName)
		if (type(_fileName) ~= 'string') then
			error('FileAssotiationsConfiguration.Constructor [fileName]: String expected, got '..type(_fileName)..'.');
		end

		fileName = _fileName;
	end

	constructor(_fileName);
end)
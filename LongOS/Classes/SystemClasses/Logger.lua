Classes.System.Logger = Class(Object, function(this, _fileName)
	Object.init(this, 'Logger');

	------------------------------------------------------------------------------------------------------------------
	----- Fileds -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local fileName;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function writeLine(_line)
		local file = fs.open(fileName, 'a');
		file.writeLine(_line);
		file.close();
	end

	function this:ClearLog()
		local file = fs.open(fileName, 'w');
		file.close();
	end

	function this:LogMessage(_message)
		writeLine('- '.._message);
	end

	function this:LogError(_errorText)
		writeLine('[ERROR] - '.._errorText);
	end

	function this:LogDebug(_debugText)
		writeLine('[DEBUG] - '.._debugText);
	end

	function this:LogWarning(_warningText)
		writeLine('[WARNING] - '.._warningText);
	end

	function this:AddDivider(_dividerName)
		writeLine('========== '.._dividerName..' ==========');
	end

	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function constructor(_fileName)
		if (type(_fileName) ~= 'string') then
			error('Logger.Constructor [fileName]: String expected, got '..type(_fileName)..'.');
		end

		fileName = _fileName;

		this:ClearLog();
	end

	constructor(_fileName);
end)
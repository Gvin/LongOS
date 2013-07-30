Logger = Class(function(this, _fileName)

	this.GetClassName = function()
		return 'Logger';
	end

	local fileName = _fileName;
	local file = fs.open(fileName, 'w');
	file.close();

	local writeLine = function(line)
		local file = fs.open(fileName, 'a');
		file.writeLine(line);
		file.close();
	end

	this.ClearLog = function(_)
		local file = fs.open(fileName, 'w');
		file.close();
	end

	this.LogMessage = function(_, message)
		writeLine('- '..message);
	end

	this.LogError = function(_, errorText)
		writeLine('[ERROR] - '..errorText);
	end

	this.LogDebug = function(_, debugText)
		writeLine('[DEBUG] - '..debugText);
	end

	this.LogWarning = function(_, warningText)
		writeLine('[WARNING] - '..warningText);
	end

	this.AddDivider = function(_, dividerName)
		writeLine('========== '..dividerName..' ==========');
	end
end)
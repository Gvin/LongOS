Configuration = Class(function(this)
	this.ClassName = 'Configuration';

	local values = {};
	
	this.ReadConfiguration = function(_, fileName)
		local file = fs.open(fileName, 'r');

		local name = file.readLine();
		while (name ~= nil and name ~= '') do
			values[name] = file.readLine();
			name = file.readLine();
		end

		file.close();
	end


	this.WriteConfiguration = function(_, fileName)
		local file = fs.open(fileName, 'w');

		for key, v in pairs(values) do
			file.writeLine(key);
			file.writeLine(values[key]);
		end

		file.close();
	end

	this.GetValue = function(_, name)
		return values[name];
	end

	this.SetValue = function(_, name, value)
		values[name] = value;
	end
end)
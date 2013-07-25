Image = Class(function(this, param1, param2)
	this.GetClassName = function()
		return "Image";
	end

	----- FIELDS -----

	local width;
	local height;
	local canvas;

	----- PROPERTIES -----

	this.GetWidth = function()
		return width;
	end

	this.GetHeight = function()
		return height;
	end

	this.GetPixel = function(_, x, y)
		return canvas[y][x];
	end

	this.SetPixel = function(_, x, y, color)
		if (type(color) ~= 'number') then
			error('Image.SetPixel [color]: number expected, got '..type(color)..'.');
		end

		if (x >= 1 and x <= with and y >= 1 and y <= height) then
			canvas[y][x] = color;
		end
	end

	----- METHODS -----

	this.SaveToFile = function(_, _fileName)
		local file = fs.open(_fileName, 'w');
		file.writeLine(with..'x'..height);
		local line = '';
		for i = 1, height do
			line = '';
			for j = 1, width do
				line = line..canvas[i][j]..' ';
			end
			file.writeLine(line);
		end
		file.close();
	end

	this.LoadFromFile = function(_, _fileName)
		if (not fs.exists(_fileName)) then
			error('Image.LoadFromFile: file with name "'.._fileName..'" doest exist.');
		end

		local file = fs.open(_fileName, 'r');
		local size = stringExtAPI.separate(file.readLine(),'x');
		width = size[1] + 0;
		height = size[2] + 0;
		canvas = {};
		for i = 1, height do
			local line = file.readLine();
			canvas[i] = stringExtAPI.separate(line, ' ');
			for j = 1, width do
				canvas[i][j] = canvas[i][j] + 0;
			end
		end
		file.close();
	end

	----- CONSTRUCTORS -----

	local constructor1 = function(_fileName)
		this:LoadFromFile(_fileName);
	end

	local constructor2 = function(_width, _height)
		with = _width;
		height = _height;
		canvas = {};
		for i = 1, height do
			canvas[i] = {};
			for j = 1, with do
				canvas[i][j] = colors.white;
			end
		end
	end

	if (type(param1) == 'string') then -- read file from disk
		constructor1(param1);
	elseif (type(param1) == 'number' and type(param2) == 'number') then -- create new image with selected size
		constructor2(param2);
	else
		error('Image.Constructor: not found constructor with such parameters ('..type(param1)..', '..type(param2)..').');
	end
end)
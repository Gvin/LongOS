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
		if (y >= 1 and y <= height and x >= 1 and x <= width) then
			return canvas[y][x];
		end
		return nil;		
	end

	this.SetPixel = function(_, x, y, color)
		if (type(color) ~= 'number') then
			error('Image.SetPixel [color]: number expected, got '..type(color)..'.');
		end

		if (x >= 1 and x <= width and y >= 1 and y <= height) then
			canvas[y][x] = color;
		end
	end

	----- METHODS -----



	local function round(_x)
		local result = _x;
		local integral, ractional = math.modf (_x);
		if ractional > 0.5 then
			result = integral + 1;
		else
			result = integral;
		end
		return result;
	end


	this.DrawLine = function(_color,_x1,_y1,_x2,_y2)	
		local xShiftCount = _x2 - _x1;		
		local yShiftCount = _y2 - _y1;		
		local count = math.max (math.abs(xShiftCount),math.abs(yShiftCount));
		xShift = xShiftCount / count;		
		yShift = yShiftCount / count;	
		local x = _x1;	
		local y = _y1;
		for i = 0,count do
			SetPixel(round(x),round(y),color);				
			x = x + xShift;	
			if (_x1==_x2)  then				
				y = y + yShift; 		
			else
				y = (y1 - y2)*x;		
				y = y +  (x1*y2 - x2*y1);		
				y = y/(x1-x2);			
			end		
		end
	end

	this.DrawRect = function(_color,_x,_y,_width,_height)		
		DrawLine(_color,_x,_y,_x + _width,_y);
		DrawLine(_color,_x + _width,_y,_x + _width,_y+_height);
		DrawLine(_color,_x,_y+_height,_x + _width,_y+_height);
		DrawLine(_color,_x,_y+_height,_x,_y);	
	end

	this.DrawEllipse = function(_color,_x,_y,_width,_height)
		local a = _width/2;
		local b = _height/2;
		local xCenter = _x + a;
		local yCenter = _y + b;
		local i =-a;
		while i<=0 do
			local y = (i*i)/(a*a);
			y = 1 - y;
			y = y * b*b;
			y = math.sqrt(y);	
			SetPixel(round(xCenter + i),round(yCenter + y),_color);
			SetPixel(round(xCenter + i),round(yCenter - y),_color);
			SetPixel(round(xCenter - i),round(yCenter + y),_color);
			SetPixel(round(xCenter - i),round(yCenter - y),_color);
			i = i + 0.05
		end
	end


	this.SaveToFile = function(_, _fileName)
		local file = fs.open(_fileName, 'w');
		file.writeLine(width..'x'..height);
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
		width = _width;
		height = _height;
		canvas = {};
		for i = 1, height do
			canvas[i] = {};
			for j = 1, width do
				canvas[i][j] = colors.white;
			end
		end
	end

	if (type(param1) == 'string') then -- read file from disk
		constructor1(param1);
	elseif (type(param1) == 'number' and type(param2) == 'number') then -- create new image with selected size
		constructor2(param1,param2);
	else
		error('Image.Constructor: not found constructor with such parameters ('..type(param1)..', '..type(param2)..').');
	end
end)
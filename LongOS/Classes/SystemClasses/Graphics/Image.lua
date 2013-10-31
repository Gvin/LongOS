Classes.System.Graphics.Image = Class(Object, function(this, param1, param2)
	Object.init(this, 'Image');

	----- FIELDS -----

	local width;
	local height;
	local canvas;

	----- PROPERTIES -----

	function this.GetWidth()
		return width;
	end

	function this.GetHeight()
		return height;
	end

	function this.SetWidth(_,_width)
		if ( type(_width) ~= 'number' ) then
			error('Image.SetWidth [width]: Number expected, got '..type(_width)..'.');
		end
		_width = math.max(_width, 1);

		if (_width >= width) then
			for j = width + 1,_width, 1 do			
				for i = 1, height do
					canvas[i][j] = colors.white;
				end
			end			
		else
			for j = _width + 1, width, 1 do			
				for i = 1, height do
					canvas[i][j] = nil;
				end
			end
		end
		width = _width;
	end

	function this.SetHeight(_,_height)
		if ( type(_height) ~= 'number' ) then
			error('Image.SetHeight [height]: Number expected, got '..type(_height)..'.');
		end
		_height = math.max(_height, 1);
		
		if (_height >= height) then
			for i = height + 1,_height do
				canvas[i] = {};
				for j = 1, width do
					canvas[i][j] = colors.white;
				end
			end	
		else
			for i = _height + 1, height do				
				for j = 1, width do
					canvas[i][j] = nil;
				end
				canvas[i] = nil;
			end		
		end	
		height = _height;
	end

	function this.GetPixel(_, x, y)
		if (y >= 1 and y <= height and x >= 1 and x <= width) then
			return canvas[y][x];
		end
		return nil;		
	end

	function this.SetPixel(_, x, y, color)
		if (type(color) ~= 'number') then
			error('Image.SetPixel [color]: number expected, got '..type(color)..'.');
		end

		if (x >= 1 and x <= width and y >= 1 and y <= height) then
			canvas[y][x] = color;
		end
	end

	----- METHODS -----

	local function round(num, idp)
    local multiplier = 10^(idp or 0);
    if num >= 0 then
      return math.floor(num * multiplier + 0.5) / multiplier;
    end
    return math.ceil(num * multiplier - 0.5) / multiplier;
  end

  local function toHex(num)
  	local hex = math.floor(math.log(num or 1)/math.log(2));
  	return string.format("%x", hex);
  end

  local function fromHex(hex)
  	return 2^tonumber(hex, 16)
  end

	function this.SetSize(_,_width,_height)			
		this:SetWidth(_width);
		this:SetHeight(_height);		 
	end

	function this.DrawLine(_,_color,_x1,_y1,_x2,_y2)			
		local xShiftCount = _x2 - _x1;		
		local yShiftCount = _y2 - _y1;		
		local count = math.max (math.abs(xShiftCount),math.abs(yShiftCount));
		xShift = xShiftCount / count;		
		yShift = yShiftCount / count;	
		local x = _x1;	
		local y = _y1;
		for i = 0,count do			
			this:SetPixel(round(x),round(y),_color);							
			x = x + xShift;	
			if (_x1==_x2)  then				
				y = y + yShift; 		
			else
				y = (_y1 - _y2)*x;		
				y = y + (_x1*_y2 - _x2*_y1);		
				y = y/(_x1 - _x2);			
			end		
		end
	end

	function this.DrawRect(_, _color,_x,_y,_width,_height)		
		this:DrawLine(_color,_x,_y,_x + _width,_y);
		this:DrawLine(_color,_x + _width,_y,_x + _width,_y+_height);
		this:DrawLine(_color,_x,_y+_height,_x + _width,_y+_height);
		this:DrawLine(_color,_x,_y+_height,_x,_y);	
	end

	function this.DrawEllipse(_, _color,_x,_y,_width,_height)
		local a = _width/2;
		local b = _height/2;
		local xCenter = _x + a;
		local yCenter = _y + b;
		for i = -a, 0, 0.05 do
			local y = (i*i)/(a*a);
			y = 1 - y;
			y = y * b*b;
			y = math.sqrt(y);	
			this:SetPixel(round(xCenter + i),round(yCenter + y),_color);
			this:SetPixel(round(xCenter + i),round(yCenter - y),_color);
			this:SetPixel(round(xCenter - i),round(yCenter + y),_color);
			this:SetPixel(round(xCenter - i),round(yCenter - y),_color);
		end
	end

	function this.SaveToFile(_, _fileName)
		local file = fs.open(_fileName, 'w');
		file.writeLine(width..'x'..height);
		local line = '';
		for i = 1, height do
	    for j = 1, width do
	      line = line..toHex(canvas[i][j])
	    end
	    line = line..'\n';
	  end
		file.write(line)
		file.close();
	end

	function this.LoadFromFile(_, _fileName)
		if (not fs.exists(_fileName)) then
			error('Image.LoadFromFile: file with name "'.._fileName..'" doest exist.');
		end

		local file = fs.open(_fileName, 'r');
		local size = stringExtAPI.separate(file.readLine(),'x');
		width = tonumber(size[1]);
		height = tonumber(size[2]);
		canvas = {};
		for i = 1, height do
			canvas[i] = {};
			local line = file.readLine();
			for j = 1, #line do
				canvas[i][j] = fromHex(line:sub(j,j))
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

	local constructor3 = function(_image)
		width = _image:GetWidth();
		height = _image:GetHeight();		
		canvas = {};
		for i = 1, height do
			canvas[i] = {};
			for j = 1, width do
				canvas[i][j] = _image:GetPixel(j,i);
			end
		end
	end

	if (type(param1) == 'string') then -- read file from disk
		constructor1(param1);
	elseif (type(param1) == 'number' and type(param2) == 'number') then -- create new image with selected size
		constructor2(param1,param2);
	elseif (type(param1) == 'table' and param1:GetClassName() == 'Image') then -- create new image from image
		constructor3(param1);
	else
		error('Image.Constructor: not found constructor with such parameters ('..type(param1)..', '..type(param2)..').');
	end
end)
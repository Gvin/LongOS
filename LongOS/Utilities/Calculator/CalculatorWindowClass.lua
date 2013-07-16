local function addValueButtonClick(params)
	params[1]:AddValue(params[2]);
end

local function clearButtonClick(params)
	params[1]:Clear();
end

local function evaluateButtonClick(params)
	params[1]:Evaluate();
end

CalculatorWindow = Class(Window, function(this, application)
	Window.init(this, application, 3, 5, 25, 12, false, true, nil, 'Gvin calculator', 'Calculator window', false);

	local dataEdit = Edit(23, nil, nil, 1, 2, 'left-top');
	this:AddComponent(dataEdit);

	-- Adding numbers buttons

	local button1 = Button(' 1 ', nil, nil, 1, 4, 'left-top');
	button1.OnClick = addValueButtonClick;
	button1.OnClickParams = { this, '1' };
	this:AddComponent(button1);

	local button2 = Button(' 2 ', nil, nil, 5, 4, 'left-top');
	button2.OnClick = addValueButtonClick;
	button2.OnClickParams = { this, '2' };
	this:AddComponent(button2);

	local button3 = Button(' 3 ', nil, nil, 9, 4, 'left-top');
	button3.OnClick = addValueButtonClick;
	button3.OnClickParams = { this, '3' };
	this:AddComponent(button3);

	local button4 = Button(' 4 ', nil, nil, 1, 6, 'left-top');
	button4.OnClick = addValueButtonClick;
	button4.OnClickParams = { this, '4' };
	this:AddComponent(button4);

	local button5 = Button(' 5 ', nil, nil, 5, 6, 'left-top');
	button5.OnClick = addValueButtonClick;
	button5.OnClickParams = { this, '5' };
	this:AddComponent(button5);

	local button6 = Button(' 6 ', nil, nil, 9, 6, 'left-top');
	button6.OnClick = addValueButtonClick;
	button6.OnClickParams = { this, '6' };
	this:AddComponent(button6);

	local button7 = Button(' 7 ', nil, nil, 1, 8, 'left-top');
	button7.OnClick = addValueButtonClick;
	button7.OnClickParams = { this, '7' };
	this:AddComponent(button7);

	local button8 = Button(' 8 ', nil, nil, 5, 8, 'left-top');
	button8.OnClick = addValueButtonClick;
	button8.OnClickParams = { this, '8' };
	this:AddComponent(button8);

	local button9 = Button(' 9 ', nil, nil, 9, 8, 'left-top');
	button9.OnClick = addValueButtonClick;
	button9.OnClickParams = { this, '9' };
	this:AddComponent(button9);

	local button0 = Button(' 0 ', nil, nil, 5, 10, 'left-top');
	button0.OnClick = addValueButtonClick;
	button0.OnClickParams = { this, '0' };
	this:AddComponent(button0);

	-- Add additional buttons

	local buttonDot = Button(' . ', nil, nil, 1, 10, 'left-top');
	buttonDot.OnClick = addValueButtonClick;
	buttonDot.OnClickParams = { this, '.' };
	this:AddComponent(buttonDot);

	local buttonClear = Button(' C ', colors.red, nil, 9, 10, 'left-top');
	buttonClear.OnClick = clearButtonClick;
	buttonClear.OnClickParams = { this };
	this:AddComponent(buttonClear);

	-- Add operations buttons

	local buttonAdd = Button(' + ', nil, nil, 15, 4, 'left-top');
	buttonAdd.OnClick = addValueButtonClick;
	buttonAdd.OnClickParams = { this, '+' };
	this:AddComponent(buttonAdd);

	local buttonSubstract = Button(' - ', nil, nil, 15, 6, 'left-top');
	buttonSubstract.OnClick = addValueButtonClick;
	buttonSubstract.OnClickParams = { this, '-' };
	this:AddComponent(buttonSubstract);

	local buttonMultiply = Button(' * ', nil, nil, 15, 8, 'left-top');
	buttonMultiply.OnClick = addValueButtonClick;
	buttonMultiply.OnClickParams = { this, '*' };
	this:AddComponent(buttonMultiply);

	local buttonDivide = Button(' / ', nil, nil, 15, 10, 'left-top');
	buttonDivide.OnClick = addValueButtonClick;
	buttonDivide.OnClickParams = { this, '/' };
	this:AddComponent(buttonDivide);

	local buttonPower = Button(' ^ ', nil, nil, 20, 4, 'left-top');
	buttonPower.OnClick = addValueButtonClick;
	buttonPower.OnClickParams = { this, '^' };
	--this:AddComponent(buttonPower);

	local buttonLeftBracket = Button(' ( ', nil, nil, 20, 6, 'left-top');
	buttonLeftBracket.OnClick = addValueButtonClick;
	buttonLeftBracket.OnClickParams = { this, '(' };
	--this:AddComponent(buttonLeftBracket);

	local buttonRightBracket = Button(' ) ', nil, nil, 20, 8, 'left-top');
	buttonRightBracket.OnClick = addValueButtonClick;
	buttonRightBracket.OnClickParams = { this, ')' };
	--this:AddComponent(buttonRightBracket);

	local buttonEvaluate = Button(' = ', colors.blue, nil, 20, 10, 'left-top');
	buttonEvaluate.OnClick = evaluateButtonClick;
	buttonEvaluate.OnClickParams = { this };
	this:AddComponent(buttonEvaluate);

	local function toNumber(value)
		return value + 0;
	end

	local function tryToNumber(value)
		local success, result = pcall(toNumber, value);
		if (success and value ~= '-') then
			return true, result;
		end

		return false;
	end

	local function separateData()
		local result = {};
		local number = true;
		local buffer = '';
		for i = 1, string.len(dataEdit.Text) do
			local char = string.sub(dataEdit.Text, i, i);
			if (tryToNumber(char) == number) then
				buffer = buffer..char;
			else
				number = tryToNumber(char);
				table.insert(result, buffer);
				buffer = char;
			end
		end

		if (buffer ~= '') then
			table.insert(result, buffer);
		end

		return result;
	end

	local function add(params)
		if (params[1] == nil or params[2] == nil) then
			error('$Wrong statement.');
		end
		return params[1] + params[2];
	end

	local function substract(params)
		if (params[1] == nil or params[2] == nil) then
			error('$Wrong statement.');
		end
		return params[1] - params[2];
	end

	local function multiply(params)
		if (params[1] == nil or params[2] == nil) then
			error('$Wrong statement.');
		end
		return params[1]*params[2];
	end

	local function divide(params)
		if (params[1] == nil or params[2] == nil) then
			error('$Wrong statement.');
		end
		return params[1]/params[2];
	end

	local function processFirstLevelOperations(data)
		local index = 1;
		while (index <= #data) do
			if (data[index] == '*') then
				local result = multiply({data[index-1], data[index+1]});
				table.remove(data, index + 1);
				table.remove(data, index);
				data[index-1] = result;
				index = index - 1;
			elseif (data[index] == '/') then
				local result = divide({data[index-1], data[index+1]});
				table.remove(data, index + 1);
				table.remove(data, index);
				data[index-1] = result;
				index = index - 1;
			end
			index = index + 1;
		end
	end

	local function processSecondLevelOperations(data)
		local index = 1;
		while (index <= #data) do
			if (data[index] == '+') then
				local result = add({data[index-1], data[index+1]});
				table.remove(data, index + 1);
				table.remove(data, index);
				data[index-1] = result;
				index = index - 1;
			elseif (data[index] == '-') then
				local result = substract({data[index-1], data[index+1]});
				table.remove(data, index + 1);
				table.remove(data, index);
				data[index-1] = result;
				index = index - 1;
			end
			index = index + 1;
		end
	end

	local function processData(data)
		processFirstLevelOperations(data);
		processSecondLevelOperations(data);
	end

	local function evaluate()
		local data = separateData();
		processData(data);
		dataEdit.Text = data[1]..'';
	end

	this.Evaluate = function(_)
		local success, message = pcall(evaluate);
		if (not success) then
			local data = stringExtAPI.separate(message, '$');
			dataEdit.Text = data[2];
		end
	end

	this.AddValue = function(_, value)
		dataEdit.Text = dataEdit.Text..value;
	end

	this.Clear = function(_)
		dataEdit.Text = '';
	end
end)
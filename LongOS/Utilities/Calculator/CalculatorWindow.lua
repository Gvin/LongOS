CalculatorWindow = Class(Window, function(this, _application)
	Window.init(this, _application, 'Calculator window', false); --, false, true, '', 3, 5, 25, 12,  25, 12, nil,  false,  true,  false);
	this:SetTitle('Calculator');
	this:SetX(3);
	this:SetY(5);
	this:SetWidth(25);
	this:SetHeight(12);
	this:SetAllowMaximize(false);
	this:SetAllowResize(false);


	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local dataEdit;
	
	-- Adding numbers buttons

	local button1;
	local button2;
	local button3;
	local button4;
	local button5;
	local button6;
	local button7;
	local button8;
	local button9;
	local button0;

	-- Add additional buttons

	local buttonDot;
	local buttonClear;

	-- Add operations buttons

	local buttonAdd;
	local buttonSubstract;
	local buttonMultiply;
	local buttonDivide;
	local buttonPower;
	local buttonLeftBracket;
	local buttonRightBracket;
	local buttonEvaluate;	

	local errorFlag;

	------------------------------------------------------------------------------------------------------------------
	----- Methods ----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------


	local function addValueButtonClick(_sender, _eventArgs)
		this:AddValue(stringExtAPI.trim(_sender:GetText()));
	end
	
	local function clearButtonClick(_sender, _eventArgs)
		this:Clear();
	end
	
	local function evaluateButtonClick(_sender, _eventArgs)
		this:Evaluate();
	end		

	local function add(param1, param2)			
		param1 = tonumber(param1);
		param2 = tonumber(param2);		
		if (param1 == nil or param2 == nil) then
			error('$Wrong statement.');
		end
		return param1 + param2;
	end

	local function substract(param1, param2)
		param1 = tonumber(param1);
		param2 = tonumber(param2);
		if (param1 == nil or param2 == nil) then
			error('$Wrong statement.');
		end
		return param1 - param2;
	end

	local function multiply(param1, param2)
		param1 = tonumber(param1);
		param2 = tonumber(param2);
		if (param1 == nil or param2 == nil) then
			error('$Wrong statement.');
		end
		return param1 * param2;
	end

	local function divide(param1, param2)		
		param1 = tonumber(param1);
		param2 = tonumber(param2);
		if (param1 == nil or param2 == nil) then
			error('$Wrong statement.');
		end
		return param1/param2;
	end

	local function multiplyDivide(numbers, signs)
		local i = 1;	
		
		while i < #numbers do								
			if (signs[i] == '*') then					
				numbers[i] = multiply(numbers[i],numbers[i+1]);								
				table.remove(numbers,i+1);	
				table.remove(signs,i);					
				i = i -1;				
			elseif(signs[i]=='/') then					
				numbers[i] = divide(numbers[i],numbers[i+1]);
				table.remove(numbers,i+1);		
				table.remove(signs,i);			
				i = i -1;				
			end
			i = i + 1;
		end	
		
	end	

	local function addSubstract(numbers, signs)
		
		local result = 0;
		for i = 1, #numbers-1 do				
			if (signs[i] == '+') then
				numbers[i] = add(numbers[i],numbers[i+1]);	
				table.remove(numbers,i+1);	
				table.remove(signs,i);					
				i = i -1;						
			elseif(signs[i]=='-') then					
				numbers[i]= substract(numbers[i],numbers[i+1]);	
				table.remove(numbers,i+1);	
				table.remove(signs,i);					
				i = i -1;							
			end	
		end		
	end		

	local function evaluate()		
		local text =dataEdit:GetText();			
		if (tonumber(string.sub(text,1,1)) == nil) then
			  text = '0'.. text;
		end		
		if #text>0 then 
			local result = 0;
			local numbers = stringExtAPI.separate(text:gsub('[-*+/]',' '),' ');
			local signs = {};			
			for s in string.gmatch(text, '[-*+/]') do
		       		table.insert(signs,s);		
		     	end
			if (tonumber(numbers[1]) == nil ) then
				error('$Wrong statement.');
			end									
			multiplyDivide(numbers,signs);
			addSubstract(numbers,signs);								
			dataEdit:SetText(numbers[1]..'');	
		end			
	end

	function this.Evaluate(_)				
		local success, message = pcall(evaluate);
		if (not success) then
			local data = stringExtAPI.separate(message, '$');			
			dataEdit:SetText(data[2]);
			errorFlag = true;
		end		
	end

	function this.AddValue(_, value)	
		if errorFlag then 
			this:Clear()
		end 	
		dataEdit:SetText(dataEdit:GetText()..value);		
	end

	function this.Clear(_)	
		errorFlag = false;		
		dataEdit:SetText('');
	end

	
	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()		

	dataEdit = Edit(23, nil, nil, 0, 1, 'left-top');
	this:AddComponent(dataEdit);

	-- Adding numbers buttons

	button1 = Button(' 1 ', nil, nil, 0, 3, 'left-top');
	button1:SetOnClick(addValueButtonClick);
	this:AddComponent(button1);

	button2 = Button(' 2 ', nil, nil, 4, 3, 'left-top');
	button2:SetOnClick(addValueButtonClick);
	this:AddComponent(button2);

	button3 = Button(' 3 ', nil, nil, 8, 3, 'left-top');
	button3:SetOnClick(addValueButtonClick);
	this:AddComponent(button3);

	button4 = Button(' 4 ', nil, nil, 0, 5, 'left-top');
	button4:SetOnClick(addValueButtonClick);
	this:AddComponent(button4);

	button5 = Button(' 5 ', nil, nil, 4, 5, 'left-top');
	button5:SetOnClick(addValueButtonClick);
	this:AddComponent(button5);

	button6 = Button(' 6 ', nil, nil, 8, 5, 'left-top');
	button6:SetOnClick(addValueButtonClick);
	this:AddComponent(button6);

	button7 = Button(' 7 ', nil, nil, 0, 7, 'left-top');
	button7:SetOnClick(addValueButtonClick);
	this:AddComponent(button7);

	button8 = Button(' 8 ', nil, nil, 4, 7, 'left-top');
	button8:SetOnClick(addValueButtonClick);
	this:AddComponent(button8);

	button9 = Button(' 9 ', nil, nil, 8, 7, 'left-top');
	button9:SetOnClick(addValueButtonClick);
	this:AddComponent(button9);

	button0 = Button(' 0 ', nil, nil, 4, 9, 'left-top');
	button0:SetOnClick(addValueButtonClick);
	this:AddComponent(button0);

	-- Add additional buttons

	buttonDot = Button(' . ', nil, nil, 0, 9, 'left-top');
	buttonDot:SetOnClick(addValueButtonClick);
	this:AddComponent(buttonDot);

	buttonClear = Button(' C ', colors.red, nil, 8, 9, 'left-top');
	buttonClear:SetOnClick(clearButtonClick);	
	this:AddComponent(buttonClear);

	-- Add operations buttons

	buttonAdd = Button(' + ', nil, nil, 14, 3, 'left-top');
	buttonAdd:SetOnClick(addValueButtonClick);
	this:AddComponent(buttonAdd);

	buttonSubstract = Button(' - ', nil, nil, 14, 5, 'left-top');
	buttonSubstract:SetOnClick(addValueButtonClick);
	this:AddComponent(buttonSubstract);

	buttonMultiply = Button(' * ', nil, nil, 14, 7, 'left-top');
	buttonMultiply:SetOnClick(addValueButtonClick);
	this:AddComponent(buttonMultiply);

	buttonDivide = Button(' / ', nil, nil, 14, 9, 'left-top');
	buttonDivide:SetOnClick(addValueButtonClick);
	this:AddComponent(buttonDivide);

	buttonPower = Button(' ^ ', nil, nil, 19, 3, 'left-top');
	--buttonPower:SetOnClick(addValueButtonClick);
	--this:AddComponent(buttonPower);

	buttonLeftBracket = Button(' ( ', nil, nil, 19, 5, 'left-top');
	--buttonLeftBracket:SetOnClick(addValueButtonClick);
	--this:AddComponent(buttonLeftBracket);

	buttonRightBracket = Button(' ) ', nil, nil, 19, 7, 'left-top');
	--buttonRightBracket:SetOnClick(addValueButtonClick);
	--this:AddComponent(buttonRightBracket);

	buttonEvaluate = Button(' = ', colors.blue, nil, 19, 9, 'left-top');
	buttonEvaluate:SetOnClick(evaluateButtonClick);	
	this:AddComponent(buttonEvaluate);

	end

	local function constructor(_application)			
		initializeComponents();	
		errorFlag = false;	
	end

	constructor(_application);

end)
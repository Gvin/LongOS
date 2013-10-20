local Window = Classes.Application.Window;
local Button = Classes.Components.Button;
local Edit = Classes.Components.Edit;

local LocalizationManager = Classes.System.Localization.LocalizationManager;

return Class(Window, function(this, _application)
	Window.init(this, _application, 'Calculator window', false);
	this:SetTitle('Calculator');
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

	local ALLOWED_CHARS = { '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '+', '*', '/' };

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
			error('$'..localizationManager:GetLocalizedString('WrongStatement'));
		end
		return param1 + param2;
	end

	local function substract(param1, param2)
		param1 = tonumber(param1);
		param2 = tonumber(param2);
		if (param1 == nil or param2 == nil) then
			error('$'..localizationManager:GetLocalizedString('WrongStatement'));
		end
		return param1 - param2;
	end

	local function multiply(param1, param2)
		param1 = tonumber(param1);
		param2 = tonumber(param2);
		if (param1 == nil or param2 == nil) then
			error('$'..localizationManager:GetLocalizedString('WrongStatement'));
		end
		return param1 * param2;
	end

	local function divide(param1, param2)		
		param1 = tonumber(param1);
		param2 = tonumber(param2);
		if (param1 == nil or param2 == nil) then
			error('$'..localizationManager:GetLocalizedString('WrongStatement'));
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
				error('$'..localizationManager:GetLocalizedString('WrongStatement'));
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

	local function filter(_char)
		return tableExtAPI.contains(ALLOWED_CHARS, _char);
	end
	
	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	local function initializeComponents()		

	dataEdit = Edit(23, nil, nil, 0, 1, 'left-top');
	dataEdit:SetFilter(filter);
	this:AddComponent(dataEdit);

	-- Adding numbers buttons

	button1 = Button(' 1 ', nil, nil, 0, 7, 'left-top');
	button1:AddOnClickEventHandler(addValueButtonClick);
	this:AddComponent(button1);

	button2 = Button(' 2 ', nil, nil, 4, 7, 'left-top');
	button2:AddOnClickEventHandler(addValueButtonClick);
	this:AddComponent(button2);

	button3 = Button(' 3 ', nil, nil, 8, 7, 'left-top');
	button3:AddOnClickEventHandler(addValueButtonClick);
	this:AddComponent(button3);

	button4 = Button(' 4 ', nil, nil, 0, 5, 'left-top');
	button4:AddOnClickEventHandler(addValueButtonClick);
	this:AddComponent(button4);

	button5 = Button(' 5 ', nil, nil, 4, 5, 'left-top');
	button5:AddOnClickEventHandler(addValueButtonClick);
	this:AddComponent(button5);

	button6 = Button(' 6 ', nil, nil, 8, 5, 'left-top');
	button6:AddOnClickEventHandler(addValueButtonClick);
	this:AddComponent(button6);

	button7 = Button(' 7 ', nil, nil, 0, 3, 'left-top');
	button7:AddOnClickEventHandler(addValueButtonClick);
	this:AddComponent(button7);

	button8 = Button(' 8 ', nil, nil, 4, 3, 'left-top');
	button8:AddOnClickEventHandler(addValueButtonClick);
	this:AddComponent(button8);

	button9 = Button(' 9 ', nil, nil, 8, 3, 'left-top');
	button9:AddOnClickEventHandler(addValueButtonClick);
	this:AddComponent(button9);

	button0 = Button(' 0 ', nil, nil, 4, 9, 'left-top');
	button0:AddOnClickEventHandler(addValueButtonClick);
	this:AddComponent(button0);

	-- Add additional buttons

	buttonDot = Button(' . ', nil, nil, 0, 9, 'left-top');
	buttonDot:AddOnClickEventHandler(addValueButtonClick);
	this:AddComponent(buttonDot);

	buttonClear = Button(' C ', colors.red, nil, 8, 9, 'left-top');
	buttonClear:AddOnClickEventHandler(clearButtonClick);	
	this:AddComponent(buttonClear);

	-- Add operations buttons

	buttonAdd = Button(' + ', nil, nil, 14, 3, 'left-top');
	buttonAdd:AddOnClickEventHandler(addValueButtonClick);
	this:AddComponent(buttonAdd);

	buttonSubstract = Button(' - ', nil, nil, 14, 5, 'left-top');
	buttonSubstract:AddOnClickEventHandler(addValueButtonClick);
	this:AddComponent(buttonSubstract);

	buttonMultiply = Button(' * ', nil, nil, 14, 7, 'left-top');
	buttonMultiply:AddOnClickEventHandler(addValueButtonClick);
	this:AddComponent(buttonMultiply);

	buttonDivide = Button(' / ', nil, nil, 14, 9, 'left-top');
	buttonDivide:AddOnClickEventHandler(addValueButtonClick);
	this:AddComponent(buttonDivide);

	buttonPower = Button(' ^ ', nil, nil, 19, 3, 'left-top');
	--buttonPower:AddOnClickEventHandler(addValueButtonClick);
	--this:AddComponent(buttonPower);

	buttonLeftBracket = Button(' ( ', nil, nil, 19, 5, 'left-top');
	--buttonLeftBracket:AddOnClickEventHandler(addValueButtonClick);
	--this:AddComponent(buttonLeftBracket);

	buttonRightBracket = Button(' ) ', nil, nil, 19, 7, 'left-top');
	--buttonRightBracket:AddOnClickEventHandler(addValueButtonClick);
	--this:AddComponent(buttonRightBracket);

	buttonEvaluate = Button(' = ', colors.blue, nil, 19, 9, 'left-top');
	buttonEvaluate:AddOnClickEventHandler(evaluateButtonClick);	
	this:AddComponent(buttonEvaluate);

	end

	local function constructor(_application)
		localizationManager = LocalizationManager(fs.combine(this:GetApplication():GetWorkingDirectory(), 'Localizations'), fs.combine(this:GetApplication():GetWorkingDirectory(), 'Localizations/default.xml'));
		localizationManager:ReadLocalization(System:GetSystemLocale());

		initializeComponents();	
		errorFlag = false;	
	end

	constructor(_application);

end)
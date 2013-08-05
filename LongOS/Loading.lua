local version = '0.2';
local operationsCount = 36;
local currentOperation = 1;
LoadingErrors = 0;

local function clearScreen()
	term.setBackgroundColor(colors.black);
	term.setTextColor(colors.white);
	term.clear();
	term.setCursorPos(1,1);
end

local function drawLoading(operation)
	local screenWidth, screenHeight = term.getSize();
	local labelPositionX = math.floor(screenWidth/2) - 10;
	local labelPositionY = math.floor(screenHeight/2);
	clearScreen();
	term.setCursorPos(labelPositionX, labelPositionY);
	term.setTextColor(colors.green);
	term.write('LongOS v'..version..' is loading');
	local position = operation/operationsCount*(screenWidth - 2);
	term.setCursorPos(1, labelPositionY + 2);
	term.setTextColor(colors.lime);
	term.write('[');
	for i = 2, position do
		term.write('=');
	end
	term.setCursorPos(screenWidth, labelPositionY + 2);
	term.write(']');
end

local function nextOperation()
	currentOperation = currentOperation + 1;
	drawLoading(currentOperation);
end

local function include(fileName)
	shell.run('/LongOS/'..fileName..'.lua');
	nextOperation();
end

include('Classes/SystemClasses/ClassBase');

if (Class == nil) then
	LoadingErrors = LoadingErrors + 1;
	error('Basic objects system cannot be loaded.');
end

include('Classes/SystemClasses/Logger');

if (Logger == nil) then
	LoadingErrors = LoadingErrors + 1;
	error('Logger class cannot be loaded.');
end

if (not fs.exists('/LongOS/Logs')) then
	fs.makeDir('/LongOS/Logs');
end
local loadingLog = Logger('/LongOS/Logs/loading.log');

local function mustBeLoaded(variable, name)
	if (variable == nil) then
		loadingLog:LogError('Class '..name..' cannot be loaded.');
		LoadingErrors = LoadingErrors + 1;
		error('Class '..name..' cannot be loaded.')
	else
		loadingLog:LogMessage('Class '..name..' successfully loaded.');
	end
end

local function shouldBeLoaded(variable, name)
	if (variable == nil) then
		loadingLog:LogWarning('Class '..name..' cannot be loaded.');
	else
		loadingLog:LogMessage('Class '..name..' successfully loaded.');
	end
end


local function includeComponents()
	loadingLog:AddDivider('Loading components');
	include('Classes/ComponentsClasses/Component');
	mustBeLoaded(Component, 'Component');
	include('Classes/ComponentsClasses/Button');
	mustBeLoaded(Button, 'Button');
	include('Classes/ComponentsClasses/Label');
	mustBeLoaded(Label, 'Label');
	include('Classes/ComponentsClasses/Edit');
	shouldBeLoaded(Edit, 'Edit');
	include('Classes/ComponentsClasses/PopupMenu');
	mustBeLoaded(PopupMenu, 'PopupMenu');
	include('Classes/ComponentsClasses/VerticalScrollBar');
	shouldBeLoaded(VerticalScrollBar, 'VerticalScrollBar');
	include('Classes/ComponentsClasses/HorizontalScrollBar');
	shouldBeLoaded(HorizontalScrollBar, 'HorizontalScrollBar');
	include('Classes/ComponentsClasses/ProgressBar');
	shouldBeLoaded(ProgressBar, 'ProgressBar');
	include('Classes/ComponentsClasses/TextBox');
	shouldBeLoaded(TextBox, 'TextBox');
	include('Classes/ComponentsClasses/CheckBox');
	shouldBeLoaded(CheckBox, 'CheckBox');
end

local function includeSystemWindows()
	loadingLog:AddDivider('Loading system windows');
	include('Classes/SystemClasses/Windows/ConfigurationWindow');
	shouldBeLoaded(ConfigurationWindow, 'ConfigurationWindow');
	include('Classes/SystemClasses//Windows/ColorConfigurationWindow');
	shouldBeLoaded(ColorConfigurationWindow, 'ColorConfigurationWindow');
	include('Classes/SystemClasses/Windows/ColorPickerDialog');
	shouldBeLoaded(ColorPickerDialog, 'ColorPickerDialog');
	include('Classes/SystemClasses/Windows/MessageWindow');
	shouldBeLoaded(MessageWindow, 'MessageWindow');
	include('Classes/SystemClasses/Windows/EnterTextDialog');
	shouldBeLoaded(EnterTextDialog, 'EnterTextDialog');
	include('Classes/SystemClasses/Windows/QuestionDialog');
	shouldBeLoaded(QuestionDialog, 'QuestionDialog');
end

local function includeApplicationClasses()
	loadingLog:AddDivider('Loading application classes');
	include('Classes/ApplicationClasses/ComponentsManager');
	mustBeLoaded(ComponentsManager, 'ComponentsManager');
	include('Classes/ApplicationClasses/MenuesManager');
	mustBeLoaded(MenuesManager, 'MenuesManager');
	include('Classes/ApplicationClasses/Window');
	mustBeLoaded(Window, 'Window');
	include('Classes/ApplicationClasses/WindowsManager');
	mustBeLoaded(WindowsManager, 'WindowsManager');
	include('Classes/ApplicationClasses/Application');
	mustBeLoaded(Application, 'Application');
end

local function includeSystemClasses()
	loadingLog:AddDivider('Loading system classes');
	include('Classes/SystemClasses/Pixel');
	mustBeLoaded(Pixel, 'Pixel');
	include('Classes/SystemClasses/VideoBuffer');
	mustBeLoaded(VideoBuffer, 'VideoBuffer');
	include('Classes/SystemClasses/Canvas');
	mustBeLoaded(Canvas, 'Canvas');
	include('Classes/SystemClasses/ApplicationsManager')
	mustBeLoaded(ApplicationsManager, 'ApplicationsManager');
	include('Classes/SystemClasses/ControlPanel');
	mustBeLoaded(ControlPanel, 'ControlPanel');
	include('Classes/SystemClasses/Image');
	mustBeLoaded(Image, 'Image');
	include('Classes/SystemClasses/Desktop');
	mustBeLoaded(Desktop, 'Desktop');
	include('Classes/SystemClasses/EventHandler');
	mustBeLoaded(EventHandler, 'EventHandler');
end

local function includeConfigurationClasses()
	include('Classes/SystemClasses/ConfigurationManager/ColorConfiguration');
	mustBeLoaded(ColorConfiguration, 'ColorConfiguration');
	include('Classes/SystemClasses/ConfigurationManager/InterfaceConfiguration');
	mustBeLoaded(InterfaceConfiguration, 'InterfaceConfiguration');
	include('Classes/SystemClasses/ConfigurationManager/MouseConfiguration');
	mustBeLoaded(MouseConfiguration, 'MouseConfiguration');
	include('Classes/SystemClasses/ConfigurationManager/ConfigurationManager');
	mustBeLoaded(ConfigurationManager, 'ConfigurationManager');
end

local function includeBaseClass()
	loadingLog:AddDivider('Loading main system class');
	include('Classes/LongOS');
	mustBeLoaded(LongOS, 'LongOS');
end

os.loadAPI('/LongOS/APIs/xmlAPI');
if (xmlAPI == nil) then
	error('xmlAPI not found in location /LongOS/APIs/');
end
os.loadAPI('/LongOS/APIs/stringExtAPI');
if (stringExtAPI == nil) then
	error('stringExtAPI not found in location /LongOS/APIs/');
end

includeSystemClasses();

includeConfigurationClasses();

includeBaseClass();

includeApplicationClasses();

includeComponents();

includeSystemWindows();

loadingLog:AddDivider('Loading finished');
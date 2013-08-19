Classes = {};
Classes.System = {};

local version = '0.4';
local operationsCount = 33;
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

if (Class == nil or Object == nil) then
	LoadingErrors = LoadingErrors + 1;
	error('Basic objects system cannot be loaded.');
end

include('Classes/SystemClasses/Logger');

if (Logger == nil) then
	LoadingErrors = LoadingErrors + 1;
	error('Logger class cannot be loaded.');
end

Classes.System.Logger = Logger;

if (not fs.exists('/LongOS/Logs')) then
	fs.makeDir('/LongOS/Logs');
end
local loadingLog = Logger('/LongOS/Logs/loading.log');

local function mustBeLoaded(variable, name, namespace)
	if (variable == nil) then
		loadingLog:LogError('Class '..name..' cannot be loaded.');
		LoadingErrors = LoadingErrors + 1;
		error('Class '..name..' cannot be loaded.')
	else
		loadingLog:LogMessage('Class '..name..' successfully loaded.');
	end

	namespace[name] = variable;
end

local function shouldBeLoaded(variable, name)
	if (variable == nil) then
		loadingLog:LogWarning('Class '..name..' cannot be loaded.');
	else
		loadingLog:LogMessage('Class '..name..' successfully loaded.');
	end
end

include('Classes/SystemClasses/EventHandler');
mustBeLoaded(EventHandler, 'EventHandler', Classes.System);
EventHandler = nil;


os.loadAPI('/LongOS/APIs/xmlAPI');
if (xmlAPI == nil) then
	error('xmlAPI not found in location /LongOS/APIs/');
end
os.loadAPI('/LongOS/APIs/stringExtAPI');
if (stringExtAPI == nil) then
	error('stringExtAPI not found in location /LongOS/APIs/');
end
os.loadAPI('/LongOS/APIs/tableExtAPI');
if (tableExtAPI == nil) then
	error('tableExtAPI not found in location /LongOS/APIs/');
end




local function includeGraphicsClasses()
	loadingLog:AddDivider('Loading graphics classes');

	include('Classes/SystemClasses/Graphics/Pixel');
	mustBeLoaded(Pixel, 'Pixel', Classes.System.Graphics);
	Pixel = nil;

	include('Classes/SystemClasses/Graphics/VideoBuffer');
	mustBeLoaded(VideoBuffer, 'VideoBuffer', Classes.System.Graphics);
	VideoBuffer = nil;

	include('Classes/SystemClasses/Graphics/Canvas');
	mustBeLoaded(Canvas, 'Canvas', Classes.System.Graphics);
	Canvas = nil;

	include('Classes/SystemClasses/Graphics/Image');
	mustBeLoaded(Image, 'Image', Classes.System.Graphics);
	Image = nil;
end

local function includeConfigurationClasses()
	loadingLog:AddDivider('Loading configuration classes');

	include('Classes/SystemClasses/ConfigurationManager/ColorConfiguration');
	mustBeLoaded(ColorConfiguration, 'ColorConfiguration', Classes.System.Configuration);
	ColorConfiguration = nil;

	include('Classes/SystemClasses/ConfigurationManager/InterfaceConfiguration');
	mustBeLoaded(InterfaceConfiguration, 'InterfaceConfiguration', Classes.System.Configuration);
	InterfaceConfiguration = nil;
	
	include('Classes/SystemClasses/ConfigurationManager/MouseConfiguration');
	mustBeLoaded(MouseConfiguration, 'MouseConfiguration', Classes.System.Configuration);
	MouseConfiguration = nil;
	
	include('Classes/SystemClasses/ConfigurationManager/ConfigurationManager');
	mustBeLoaded(ConfigurationManager, 'ConfigurationManager', Classes.System.Configuration);
	ConfigurationManager = nil;
end

local function includeComponentsClasses()
	loadingLog:AddDivider('Loading components classes');

	include('Classes/ComponentsClasses/Component');
	mustBeLoaded(Component, 'Component', Classes.Components);
	Component = nil;

	include('Classes/ComponentsClasses/Label');
	mustBeLoaded(Label, 'Label', Classes.Components);
	Label = nil;

	include('Classes/ComponentsClasses/Button');
	mustBeLoaded(Button, 'Button', Classes.Components);
	Button = nil;

	include('Classes/ComponentsClasses/Edit');
	mustBeLoaded(Edit, 'Edit', Classes.Components);
	Edit = nil;

	include('Classes/ComponentsClasses/PopupMenu');
	mustBeLoaded(PopupMenu, 'PopupMenu', Classes.Components);
	PopupMenu = nil;

	include('Classes/ComponentsClasses/VerticalScrollBar');
	mustBeLoaded(VerticalScrollBar, 'VerticalScrollBar', Classes.Components);
	VerticalScrollBar = nil;

	include('Classes/ComponentsClasses/HorizontalScrollBar');
	mustBeLoaded(HorizontalScrollBar, 'HorizontalScrollBar', Classes.Components);
	HorizontalScrollBar = nil;
end

local function includeApplicationClasses()
	loadingLog:AddDivider('Loading application classes');

	include('Classes/ApplicationClasses/ComponentsManager');
	mustBeLoaded(ComponentsManager, 'ComponentsManager', Classes.Application);
	ComponentsManager = nil;

	include('Classes/ApplicationClasses/MenuesManager');
	mustBeLoaded(MenuesManager, 'MenuesManager', Classes.Application);
	MenuesManager = nil;
	
	include('Classes/ApplicationClasses/Window');
	mustBeLoaded(Window, 'Window', Classes.Application);
	Window = nil;
	
	include('Classes/ApplicationClasses/WindowsManager');
	mustBeLoaded(WindowsManager, 'WindowsManager', Classes.Application);
	WindowsManager = nil;
	
	include('Classes/ApplicationClasses/Thread');
	mustBeLoaded(Thread, 'Thread', Classes.Application);
	Thread = nil;
	
	include('Classes/ApplicationClasses/ThreadsManager');
	mustBeLoaded(ThreadsManager, 'ThreadsManager', Classes.Application);
	ThreadsManager = nil;
	
	include('Classes/ApplicationClasses/Application');
	mustBeLoaded(Application, 'Application', Classes.Application);
	Application = nil;
end

local function includeSystemWindows()
	loadingLog:AddDivider('Loading system windows');

	include('Classes/SystemClasses/Windows/ColorPickerDialog');
	mustBeLoaded(ColorPickerDialog, 'ColorPickerDialog', Classes.System.Windows);
	ColorPickerDialog = nil;

	include('Classes/SystemClasses/Windows/MessageWindow');
	mustBeLoaded(MessageWindow, 'MessageWindow', Classes.System.Windows);
	MessageWindow = nil;

	include('Classes/SystemClasses/Windows/EnterTextDialog');
	mustBeLoaded(EnterTextDialog, 'EnterTextDialog', Classes.System.Windows);
	EnterTextDialog = nil;

	include('Classes/SystemClasses/Windows/QuestionDialog');
	mustBeLoaded(QuestionDialog, 'QuestionDialog', Classes.System.Windows);
	QuestionDialog = nil;
end

local function includeSystemClasses()
	loadingLog:AddDivider('Loading system classes');
	
	include('Classes/SystemClasses/ApplicationsManager')
	mustBeLoaded(ApplicationsManager, 'ApplicationsManager', Classes.System);
	ApplicationsManager = nil;
	
	include('Classes/SystemClasses/ControlPanel');
	mustBeLoaded(ControlPanel, 'ControlPanel', Classes.System);
	ControlPanel = nil;
	
	include('Classes/SystemClasses/Desktop');
	mustBeLoaded(Desktop, 'Desktop', Classes.System);
	Desktop = nil;
end

local function includeBaseClass()
	loadingLog:AddDivider('Loading main system class');
	include('Classes/LongOS');
	mustBeLoaded(LongOS, 'LongOS', Classes.System);
	LongOS = nil;
end


Classes.System.Graphics = {};
Classes.System.Configuration = {};
Classes.System.Windows = {};
Classes.Components = {};
Classes.Application = {};

includeGraphicsClasses();
includeConfigurationClasses();
includeComponentsClasses();
includeApplicationClasses();
includeSystemWindows();
includeSystemClasses();
includeBaseClass();


loadingLog:AddDivider('Loading finished');
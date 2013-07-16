local version = '0.1';
local operationsCount = 31;
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

include('Classes/SystemClasses/LoggerClass');

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
	include('Classes/ComponentsClasses/ComponentClass');
	mustBeLoaded(Component, 'Component');
	include('Classes/ComponentsClasses/ButtonClass');
	mustBeLoaded(Button, 'Button');
	include('Classes/ComponentsClasses/LabelClass');
	mustBeLoaded(Label, 'Label');
	include('Classes/ComponentsClasses/EditClass');
	shouldBeLoaded(Edit, 'Edit');
	include('Classes/ComponentsClasses/PopupMenuClass');
	mustBeLoaded(PopupMenu, 'PopupMenu');
	include('Classes/ComponentsClasses/VerticalScrollBarClass');
	shouldBeLoaded(VerticalScrollBar, 'VerticalScrollBar');
	include('Classes/ComponentsClasses/HorizontalScrollBarClass');
	shouldBeLoaded(HorizontalScrollBar, 'HorizontalScrollBar');
	include('Classes/ComponentsClasses/ProgressBarClass');
	shouldBeLoaded(ProgressBar, 'ProgressBar');
	include('Classes/ComponentsClasses/TextBoxClass');
	shouldBeLoaded(TextBox, 'TextBox');
	include('Classes/ComponentsClasses/CheckBoxClass');
	shouldBeLoaded(CheckBox, 'CheckBox');
end

local function includeSystemWindows()
	loadingLog:AddDivider('Loading system windows');
	include('Classes/SystemClasses/Windows/ConfigurationWindowClass');
	shouldBeLoaded(ConfigurationWindow, 'ConfigurationWindow');
	include('Classes/SystemClasses//Windows/ColorConfigurationWindowClass');
	shouldBeLoaded(ColorConfigurationWindow, 'ColorConfigurationWindow');
	include('Classes/SystemClasses/Windows/ColorPickerWindowClass');
	shouldBeLoaded(ColorPickerWindow, 'ColorPickerWindow');
	include('Classes/SystemClasses/Windows/MessageWindowClass');
	shouldBeLoaded(MessageWindow, 'MessageWindow');
	include('Classes/SystemClasses/Windows/OpenFileWindowClass');
	shouldBeLoaded(OpenFileWindow, 'OpenFileWindow');
	include('Classes/SystemClasses/Windows/DialogWindowClass');
	shouldBeLoaded(DialogWindow, 'DialogWindow');
end

local function includeApplicationClasses()
	loadingLog:AddDivider('Loading application classes');
	include('Classes/ApplicationClasses/ComponentsManagerClass');
	mustBeLoaded(ComponentsManager, 'ComponentsManager');
	include('Classes/ApplicationClasses/MenuesManagerClass');
	mustBeLoaded(MenuesManager, 'MenuesManager');
	include('Classes/ApplicationClasses/WindowClass');
	mustBeLoaded(Window, 'Window');
	include('Classes/ApplicationClasses/WindowsManagerClass');
	mustBeLoaded(WindowsManager, 'WindowsManager');
	include('Classes/ApplicationClasses/ApplicationClass');
	mustBeLoaded(Application, 'Application');
end

local function includeSystemClasses()
	loadingLog:AddDivider('Loading system classes');
	include('Classes/SystemClasses/VideoBufferClass');
	mustBeLoaded(VideoBuffer, 'VideoBuffer');
	include('Classes/SystemClasses/ApplicationsManagerClass')
	mustBeLoaded(ApplicationsManager, 'ApplicationsManager');
	include('Classes/SystemClasses/TimerClass');
	mustBeLoaded(Timer, 'Timer');
	include('Classes/SystemClasses/ModemMonitorClass');
	mustBeLoaded(ModemMonitor, 'ModemMonitor');
	include('Classes/SystemClasses/ControlPanelClass');
	mustBeLoaded(ControlPanel, 'ControlPanel');
	include('Classes/SystemClasses/DesktopClass');
	mustBeLoaded(Desktop, 'Desktop');
	include('Classes/SystemClasses/ConfigurationClass');
	mustBeLoaded(Configuration, 'Configuration');
	include('Classes/SystemClasses/ConfigurationManager/ColorConfiguration');
	mustBeLoaded(ColorConfiguration, 'ColorConfiguration');
	include('Classes/SystemClasses/ConfigurationManager/InterfaceConfiguration');
	mustBeLoaded(InterfaceConfiguration, 'InterfaceConfiguration');
end

local function includeBaseClass()
	loadingLog:AddDivider('Loading main system class');
	include('Classes/LongOSClass');
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

includeApplicationClasses();

includeComponents();

includeSystemWindows();

includeBaseClass();

loadingLog:AddDivider('Loading finished');
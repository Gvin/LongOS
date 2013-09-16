Classes = {};
Classes.System = {};
Classes.System.Graphics = {};
Classes.Components = {};
Classes.Aplication = {};

local version = '1.0';
local operationsCount = 37;
local currentOperation = 1;
LoadingErrors = 0;

local screenWidth, screenHeight = term.getSize();
local logotype = {
	{ 2, 2, 2, 2, 2048, 2, 2, 2, 2048, 2048, 2 },
	{ 2, 32, 2, 2048, 2, 2048, 2, 2048, 2, 2, 2 },
	{ 2, 32, 128, 2, 2048, 2, 2, 2, 2048, 2, 2 },
	{ 2, 32, 128, 2, 2, 2, 2, 2, 2, 2048, 2 },
	{ 2, 32, 32, 32, 32, 2, 2, 2048, 2048, 2, 2 },
	{ 2, 2, 128, 128, 128, 128, 2, 2, 2, 2, 2 },
	{ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, }
}

local function clearScreen(color)
	if (not color) then
		color = colors.black;
	end
	term.setBackgroundColor(color);
	term.clear();
	term.setCursorPos(1,1);
end

local function drawHorizontalLine(y, width)
	term.setCursorPos(1, y);
	write('+');
	for i = 2, width - 1 do
		write('-');
	end
	write('+');
end

local function drawVerticalLine(width, height)
	for i = 2, height - 1 do
		term.setCursorPos(1, i);
		write('|');
		term.setCursorPos(width, i);
		write('|');
	end
end

-- Draw screen base
clearScreen(colors.lightGray);
term.setTextColor(colors.black);
drawHorizontalLine(1, screenWidth);
drawHorizontalLine(screenHeight, screenWidth);
drawVerticalLine(screenWidth, screenHeight);
local labelPositionX = math.floor(screenWidth/2) - 10;
local labelPositionY = math.floor(screenHeight/2) - 5;
term.setCursorPos(labelPositionX, labelPositionY);
term.setTextColor(colors.green);
term.write('LongOS v'..version..' is loading');
paintutils.drawLine(2, labelPositionY + 1, screenWidth - 1, labelPositionY + 1, colors.gray);
paintutils.drawPixel(2, labelPositionY + 2, colors.gray);
paintutils.drawPixel(screenWidth - 1, labelPositionY + 2, colors.gray);
paintutils.drawLine(2, labelPositionY + 3, screenWidth - 1, labelPositionY + 3, colors.gray);
paintutils.drawLine(3, labelPositionY + 2, screenWidth - 2, labelPositionY + 2, colors.red);
-- Draw logotype
for i = 1, 7 do
	for j = 1, 11 do
		paintutils.drawPixel(labelPositionX + j + 4, labelPositionY + i + 4, logotype[i][j]);
	end
end


local function drawLoading(operation)	
	local position = operation/operationsCount*(screenWidth - 6);
	paintutils.drawLine(3, labelPositionY + 2, 3 + position, labelPositionY + 2, colors.lime);
	term.setCursorPos(1, 19);
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

if (Classes.System.Logger == nil) then
	LoadingErrors = LoadingErrors + 1;
	error('Logger class cannot be loaded.');
end

if (not fs.exists('/LongOS/Logs')) then
	fs.makeDir('/LongOS/Logs');
end
local loadingLog = Classes.System.Logger('/LongOS/Logs/loading.log');

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

include('Classes/SystemClasses/EventHandler');
mustBeLoaded(Classes.System.EventHandler, 'EventHandler');
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
	mustBeLoaded(Classes.System.Graphics.Pixel, 'Pixel');

	include('Classes/SystemClasses/Graphics/VideoBuffer');
	mustBeLoaded(Classes.System.Graphics.VideoBuffer, 'VideoBuffer');

	include('Classes/SystemClasses/Graphics/Canvas');
	mustBeLoaded(Classes.System.Graphics.Canvas, 'Canvas');

	include('Classes/SystemClasses/Graphics/Image');
	mustBeLoaded(Classes.System.Graphics.Image, 'Image');
end

local function includeConfigurationClasses()
	loadingLog:AddDivider('Loading configuration classes');

	include('Classes/SystemClasses/ConfigurationManager/ColorConfiguration');
	mustBeLoaded(Classes.System.Configuration.ColorConfiguration, 'ColorConfiguration');

	include('Classes/SystemClasses/ConfigurationManager/InterfaceConfiguration');
	mustBeLoaded(Classes.System.Configuration.InterfaceConfiguration, 'InterfaceConfiguration');
	
	include('Classes/SystemClasses/ConfigurationManager/MouseConfiguration');
	mustBeLoaded(Classes.System.Configuration.MouseConfiguration, 'MouseConfiguration');

	include('Classes/SystemClasses/ConfigurationManager/ApplicationsConfiguration');
	mustBeLoaded(Classes.System.Configuration.ApplicationsConfiguration, 'ApplicationsConfiguration');

	include('Classes/SystemClasses/ConfigurationManager/FileAssotiationsConfiguration');
	mustBeLoaded(Classes.System.Configuration.FileAssotiationsConfiguration, 'FileAssotiationsConfiguration');
	
	include('Classes/SystemClasses/ConfigurationManager/ConfigurationManager');
	mustBeLoaded(Classes.System.Configuration.ConfigurationManager, 'ConfigurationManager');
end

local function includeComponentsClasses()
	loadingLog:AddDivider('Loading components classes');

	include('Classes/ComponentsClasses/Component');
	mustBeLoaded(Classes.Components.Component, 'Component');

	include('Classes/ComponentsClasses/Label');
	mustBeLoaded(Classes.Components.Label, 'Label');

	include('Classes/ComponentsClasses/Button');
	mustBeLoaded(Classes.Components.Button, 'Button');

	include('Classes/ComponentsClasses/Edit');
	mustBeLoaded(Classes.Components.Edit, 'Edit');

	include('Classes/ComponentsClasses/PopupMenu');
	mustBeLoaded(Classes.Components.PopupMenu, 'PopupMenu');

	include('Classes/ComponentsClasses/VerticalScrollBar');
	mustBeLoaded(Classes.Components.VerticalScrollBar, 'VerticalScrollBar');

	include('Classes/ComponentsClasses/HorizontalScrollBar');
	mustBeLoaded(Classes.Components.HorizontalScrollBar, 'HorizontalScrollBar');

	include('Classes/ComponentsClasses/ListBox');
	mustBeLoaded(Classes.Components.ListBox, 'ListBox');

	include('Classes/ComponentsClasses/CheckBox');
	mustBeLoaded(Classes.Components.CheckBox, 'CheckBox');
end

local function includeApplicationClasses()
	loadingLog:AddDivider('Loading application classes');

	include('Classes/ApplicationClasses/ComponentsManager');
	mustBeLoaded(Classes.Application.ComponentsManager, 'ComponentsManager');

	include('Classes/ApplicationClasses/MenuesManager');
	mustBeLoaded(Classes.Application.MenuesManager, 'MenuesManager');
	
	include('Classes/ApplicationClasses/Window');
	mustBeLoaded(Classes.Application.Window, 'Window');
	
	include('Classes/ApplicationClasses/WindowsManager');
	mustBeLoaded(Classes.Application.WindowsManager, 'WindowsManager');
	
	include('Classes/ApplicationClasses/Thread');
	mustBeLoaded(Classes.Application.Thread, 'Thread');
	
	include('Classes/ApplicationClasses/ThreadsManager');
	mustBeLoaded(Classes.Application.ThreadsManager, 'ThreadsManager');
	
	include('Classes/ApplicationClasses/Application');
	mustBeLoaded(Classes.Application.Application, 'Application');
end

local function includeSystemWindows()
	loadingLog:AddDivider('Loading system windows');

	include('Classes/SystemClasses/Windows/ColorPickerDialog');
	mustBeLoaded(Classes.System.Windows.ColorPickerDialog, 'ColorPickerDialog');

	include('Classes/SystemClasses/Windows/MessageWindow');
	mustBeLoaded(Classes.System.Windows.MessageWindow, 'MessageWindow');

	include('Classes/SystemClasses/Windows/EnterTextDialog');
	mustBeLoaded(Classes.System.Windows.EnterTextDialog, 'EnterTextDialog');

	include('Classes/SystemClasses/Windows/QuestionDialog');
	mustBeLoaded(Classes.System.Windows.QuestionDialog, 'QuestionDialog');
end

local function includeSystemClasses()
	loadingLog:AddDivider('Loading system classes');
	
	include('Classes/SystemClasses/ApplicationsManager')
	mustBeLoaded(Classes.System.ApplicationsManager, 'ApplicationsManager');
	
	include('Classes/SystemClasses/ControlPanel');
	mustBeLoaded(Classes.System.ControlPanel, 'ControlPanel');
	
	include('Classes/SystemClasses/Desktop');
	mustBeLoaded(Classes.System.Desktop, 'Desktop');
end

local function includeBaseClass()
	loadingLog:AddDivider('Loading main system class');
	include('Classes/LongOS');
	mustBeLoaded(Classes.System.LongOS, 'LongOS');
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
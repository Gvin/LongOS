local REPOSITORY_URL = 'https://raw.github.com/Gvin/LongOS';
local RETRY_ATTEMPTS = 3;
local LOGOTYPE_IMAGE = {
	{ 2, 2, 2, 2, 2048, 2, 2, 2, 2048, 2048, 2 },
	{ 2, 32, 2, 2048, 2, 2048, 2, 2048, 2, 2, 2 },
	{ 2, 32, 128, 2, 2048, 2, 2, 2, 2048, 2, 2 },
	{ 2, 32, 128, 2, 2, 2, 2, 2, 2, 2048, 2 },
	{ 2, 32, 32, 32, 32, 2, 2, 2048, 2048, 2, 2 },
	{ 2, 2, 128, 128, 128, 128, 2, 2, 2, 2, 2 },
	{ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, }
}

local screenWidth, screenHeight = term.getSize();
local labelPositionX = math.floor(screenWidth/2) - 16;
local labelPositionY = math.floor(screenHeight/2) - 5;
local osVersion = 'v-';
local currentCount = 0;
local count = 1;


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

local function drawScreenBase()
	-- Draw screen base
	clearScreen(colors.lightGray);
	term.setTextColor(colors.black);
	drawHorizontalLine(1, screenWidth);
	drawHorizontalLine(screenHeight, screenWidth);
	drawVerticalLine(screenWidth, screenHeight);
	paintutils.drawLine(2, labelPositionY + 1, screenWidth - 1, labelPositionY + 1, colors.gray);
	paintutils.drawPixel(2, labelPositionY + 2, colors.gray);
	paintutils.drawPixel(screenWidth - 1, labelPositionY + 2, colors.gray);
	paintutils.drawLine(2, labelPositionY + 3, screenWidth - 1, labelPositionY + 3, colors.gray);
	paintutils.drawLine(3, labelPositionY + 2, screenWidth - 2, labelPositionY + 2, colors.red);
	-- Draw logotype
	for i = 1, 7 do
		for j = 1, 11 do
			paintutils.drawPixel(labelPositionX + j + 9, labelPositionY + i + 4, LOGOTYPE_IMAGE[i][j]);
		end
	end
end

local function countFiles(filesTree)
	local count = 0;
	for i = 1, #filesTree do
		if (filesTree[i].IsDir) then
			count = count + countFiles(filesTree[i].Content);
		else
			count = count + 1;
		end
	end
	return count;
end

local function updateScreen(fileName)
	currentCount = currentCount + 1;
	local position = math.floor(currentCount/count*(screenWidth - 6));
	paintutils.drawLine(3, labelPositionY + 2, 3 + position, labelPositionY + 2, colors.lime);
	term.setCursorPos(labelPositionX, labelPositionY);
	term.setTextColor(colors.green);
	term.setBackgroundColor(colors.lightGray);
	term.write('LongOS '..osVersion..' is downloading ['..currentCount..'/'..count..']');
	term.setCursorPos(2, 18);
	term.write(string.rep(' ', screenWidth - 2));
	term.setCursorPos(2, 18);
	term.write(fileName);
end

local function getFileData(url)
	for i = 1, RETRY_ATTEMPTS do
		local file = http.get(url);
		if (file ~= nil) then
			local data = file.readAll();
			file.close();
			return data;
		end
	end
	return nil;
end

local function downloadFile(url, absoluteFileName)
	updateScreen(fs.getName(absoluteFileName));
	local fileData = getFileData(url);
	if (fileData == nil) then
		term.setTextColor(colors.red);
		term.setCursorPos(2, screenHeight - 3);
		term.write('Unable to retrieve file:');
		term.setTextColor(colors.black);
		term.setCursorPos(2, screenHeight - 2);
		term.write(string.rep(' ', screenWidth - 2));
		term.setCursorPos(2, screenHeight - 2);
		term.write(fs.getName(absoluteFileName));
		term.setTextColor(colors.red);
		term.setCursorPos(2, screenHeight - 1);
		term.write('Downloading stopped. Press ENTER to exit.');
		return false;
	end
	local file = fs.open(absoluteFileName, 'w');
	file.write(fileData);
	file.close();
	return true;
end

local function processFilesTreeRec(tree, path, urlPath)
	for i = 1, #tree do
		if (tree[i].IsDir) then
			fs.makeDir(path..tree[i].Name);
			if (not processFilesTreeRec(tree[i].Content, path..tree[i].Name..'/', urlPath..tree[i].Name..'/')) then
				return false;
			end
		else
			if (not downloadFile(REPOSITORY_URL..'/'..osVersion..urlPath..tree[i].Name, path..tree[i].Name)) then
				return false;
			end
		end
	end
	return true;
end

local function processFilesTree(tree, path)
	if (not	processFilesTreeRec(tree, path, '/LongOS/')) then
		read();
		return false;
	end
	return true;
end

term.setTextColor(colors.lime);
print('LongOS downloader started.');
print('Press ENTER to start downloading process.');
print('LongOS will be placed at: "/" folder.');
--print('Specify path for downloading:');
--local path = read();
read();
path = '/';

clearScreen(colors.lightGray);
if (not downloadFile(REPOSITORY_URL..'/master/tree.lua', '/tree.lua')) then
	term.setCursorPos(1, screenHeight);
	return;
end
shell.run('/tree.lua');
fs.delete('/tree.lua');
osVersion = version;
local filesTree = tree;

drawScreenBase();
term.setBackgroundColor(colors.black);
count = countFiles(filesTree) + 1;
if (not processFilesTree(filesTree, path..'/LongOS/')) then
	clearScreen(colors.black);
	return;
end
clearScreen(colors.black);
term.setTextColor(colors.lime);
print('Downloading finished.');
local ansvered = false;
while (not ansvered) do
	print('Set LongOS on startup? (Y/n)');
	local ansver = read();
	if (ansver == '' or ansver == 'y' or ansver == 'Y') then
		local file = fs.open('startup', 'w');
		file.writeLine("shell.run('"..path.."/LongOS/Long');");
		file.close();
		print('Startup file created.');
		ansvered = true;
	elseif (ansver == 'n' or ansver == 'N') then
		ansvered = true;
	end
end
print('Installation completed. Press ENTER to exit setup.');
read();
clearScreen(colors.black);
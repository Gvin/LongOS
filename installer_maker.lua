local function readDirectory(path)
	local list = fs.list(path);
	local result = {};
	for i = 1, #list do
		if (list[i] ~= 'Logs' and list[i] ~= 'Temp') then
			local data = {};
			data.Name = list[i];
			data.IsDir = fs.isDir(path..'/'..list[i]);
			if (data.IsDir) then
				data.Content = readDirectory(path..'/'..list[i]..'/');
			end
			table.insert(result, data);
		end
		sleep(0.01);
	end
	return result;
end

local function printDirectory(data, spacer)
	for i = 1, #data do
		print(spacer..data[i].Name);
		if (data[i].IsDir) then
			printDirectory(data[i].Content, spacer..'-');
		end
		sleep(0.01);
	end
end

local function writeDirectories(data, spacer, file)
	for i = 1, #data do
		file.writeLine(spacer..'{');
		file.writeLine(spacer..'\tName = "'..data[i].Name..'",');
		if (data[i].IsDir) then
			file.writeLine(spacer..'\tIsDir = true,');
			file.writeLine(spacer..'\tContent = {');
			writeDirectories(data[i].Content, spacer..'\t\t', file);
			file.writeLine(spacer..'\t}');
		else
			file.writeLine(spacer..'\tIsDir = false');
		end
		if (i == #data) then
			file.writeLine(spacer..'}');
		else
			file.writeLine(spacer..'},');
		end
		sleep(0.01);
	end
end

print('Enter working path:');
local workPath = read();
print('Enter version:');
local version = read();
print('Reading files and directories...');
local data = readDirectory(workPath);
print('Reading finished.');
print('Directory tree:');
printDirectory(data, '');
print('Writing to file...');
local file = fs.open('/tree.lua', 'w');
file.writeLine('version = "'..version..'";');
file.writeLine();
file.writeLine('tree = {');
writeDirectories(data, '\t', file);
file.writeLine('};');
file.close();
print('Finished writing.');
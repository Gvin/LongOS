local function split(str, patt)
  local t = {}
  for s in str:gmatch("[^"..patt.."]+") do
    table.insert(t,s)
  end
  return t
end

local function toHex(num)
  local hex = math.floor(math.log(num or 1)/math.log(2));
  return string.format("%x", hex);
end

local function fromHex(hex)
  return 2^tonumber(hex, 16)
end

local canvas, width, height;

local function SaveToFile(_fileName)
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

local function LoadFromFile(_fileName)
  if (not fs.exists(_fileName)) then
    error('Image.LoadFromFile: file with name "'.._fileName..'" doest exist.');
  end

  local file = fs.open(_fileName, 'r');
  local size = split(file.readLine(),'x');
  width = size[1] + 0;
  height = size[2] + 0;
  canvas = {};
  for i = 1, height do
    local line = file.readLine();
    canvas[i] = split(line, ' ');
    for j = 1, width do
      canvas[i][j] = canvas[i][j] + 0;
    end
  end
  file.close();
end

local base = "/LongOS/LongOS/Wallpapers/"
local files = {
  "angry_birds",
  "computer",
  "creaper",
  "girls-HD-60x40",
}

for _,v in pairs(files) do
  LoadFromFile(base..v..".image")
  SaveToFile(base..v..".image")
end
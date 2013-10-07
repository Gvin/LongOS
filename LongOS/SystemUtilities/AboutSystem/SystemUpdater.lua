
SystemUpdater = Class(Object, function(this)
	Object.init(this, 'SystemUpdater');


	------------------------------------------------------------------------------------------------------------------
	----- Fields -----------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------


	local repositoryUrl = 'https://raw.github.com/Gvin/LongOS';
	local currentVersion;
	local currentTree;
	
	local retryAttempts = 3;

	local filesCount = 0;
	local currentCount = 0;

	

	local lastVersion;
	local lastTree;
	local currentTree;	

	----------------------------------------------------
	---Methods--------------------------
	----------------------------------------------------

	function this:GetUpdateCompleted()
		return updateCompleted;
	end


	function this:GetProgress()
		return currentCount,filesCount;
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


	local function getFileData(url)
		for i = 1, retryAttempts do
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
		local fileData = getFileData(url);
		if (fileData == nil) then			
			return false;
		end
		local file = fs.open(absoluteFileName, 'w');
		file.write(fileData);
		file.close();
		currentCount = currentCount + 1;
		return true;
	end

	local function downloadFilesTreeRec(tree, path, urlPath)
		for i = 1, #tree do
			if (tree[i].IsDir) then
				fs.makeDir(path..tree[i].Name);
				if (not downloadFilesTreeRec(tree[i].Content, path..tree[i].Name..'/', urlPath..tree[i].Name..'/')) then
					return false;
				end
			else
				if (not downloadFile(repositoryUrl..'/v'..lastVersion..urlPath..tree[i].Name, path..tree[i].Name)) then
					return false;
				end
			end
		end
		return true;
	end
	
	local function downloadFilesTree(tree, path)
		if (not downloadFilesTreeRec(tree, path, '/LongOS/')) then			
			return false;
		end
		return true;
	end




	local function deleteFilesTreeRec(tree, urlPath)
		for i = 1, #tree do
			if (tree[i].IsDir) then			
				if (not deleteFilesTreeRec(tree[i].Content, urlPath..tree[i].Name..'/')) then
					return false;
				end
			else
				fs.delete(urlPath..tree[i].Name)			
			end
		end
		return true;
	end
	
	local function deleteFilesTree(tree)
		if (not deleteFilesTreeRec(tree, System:ResolvePath("%SYSDIR%/"))) then			
			return false;
		end
		return true;
	end


	local function moveFilesTreeRec(tree, path, urlPath)
		for i = 1, #tree do
			if (tree[i].IsDir) then	
				fs.makeDir(path..tree[i].Name);		
				if (not moveFilesTreeRec(tree[i].Content, path..tree[i].Name..'/' ,urlPath..tree[i].Name..'/')) then
					return false;
				end
			else
				if (fs.exists(urlPath..tree[i].Name)) then
					fs.delete(urlPath..tree[i].Name);
				end
				fs.move(urlPath..tree[i].Name, path..tree[i].Name);					
			end
		end
		return true;
	end
	
	local function moveFilesTree(tree)
		if (not moveFilesTreeRec(tree, System:ResolvePath("%SYSDIR%/"), System:ResolvePath("%SYSDIR%/Temp/LongOS/") )) then			
			return false;
		end
		return true;
	end



	
	local function checkPath(path)
		fs.makeDir(path);
		return fs.isDir(path);
	end

	local function correctTree(_tree)
		local config;		
		for i = 1, #_tree do			
			if (_tree[i].Name == 'Configuration') then									
				config = _tree[i].Content;
			end
		end
		for i = 1, #config do
			if (config[i].Name == "applications_configuration.xml") then
				config[i] = nil;
			elseif(config[i].Name == "autoexec") then
				config[i] = nil;
			elseif(config[i].Name == "color_schema.xml") then
				config[i] = nil;
			elseif(config[i].Name == "interface_configuration.xml") then
				config[i] = nil;
			elseif(config[i].Name == "mouse_configuration.xml") then
				config[i] = nil;
			end
		end
	end

	local function getCurrentTree()		
		downloadFile(repositoryUrl..'/v'..System:GetCurrentVersion()..'/tree.lua', '/currentTree.lua');
		if (fs.exists('/currentTree.lua')) then
			shell.run('/currentTree.lua');
			fs.delete('/currentTree.lua');
			currentTree = tree;
			tree = null;
		end
	end

	local function checkNewVersion()
		downloadFile(repositoryUrl..'/master/tree.lua', '/tree.lua');
		if (fs.exists('/tree.lua')) then
			shell.run('/tree.lua');
			fs.delete('/tree.lua');
			lastVersion = version;
			lastTree = tree;
			tree = nil;
			version = nil;	
		end	
	end
	
	function this:GetLastVersion()
		if (lastVersion == nil) then
			checkNewVersion();
		end
		return lastVersion;
	end

	local function copyFiles()
		moveFilesTree(lastTree)			
	end

	local function deleteOldVersion()		
		deleteFilesTree(currentTree);		
	end

	function this:UpdateVersion()
		if (lastTree == nil) then
			checkNewVersion();			
		end
		correctTree(lastTree);	
		getCurrentTree();	
		correctTree(currentTree);			
		filesCount = countFiles(lastTree);	
		currentCount = 0;			
		downloadFilesTree(lastTree,System:ResolvePath("%SYSDIR%/Temp/LongOS/"));
		deleteOldVersion();
		copyFiles();	
	end	


	------------------------------------------------------------------------------------------------------------------
	----- Constructors -----------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	

	local function constructor()		
		currentVersion = System:GetCurrentVersion();		
	end

	constructor();

end)
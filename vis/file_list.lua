-- Variables
local PathList = {}
local NameList = {}
local CurrentFileNumber = 0

-- Functions
function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function FormatName(str)
	local name = str:gsub('.*/', '')
	return name
end

-- Vis commands
vis:command_register('ba', function(argv, force, win, cursor, range)
	local file = vis.win.file
	if PathList[CurrentFileNumber] == file.path then
		-- Do nothing
	else
		CurrentFileNumber = CurrentFileNumber + 1
		table.insert(PathList, CurrentFileNumber, file.path)
		table.insert(NameList, CurrentFileNumber, FormatName(file.name))
	end
end, 'Add file to file list')

vis:command_register('bn', function(argv, force, win, cursor, range)
	CurrentFileNumber = (CurrentFileNumber % tablelength(PathList)) + 1
	vis:command('e ' .. PathList[CurrentFileNumber])
end, 'Switch to next file in file list')

vis:command_register('bp', function(argv, force, win, cursor, range)
	CurrentFileNumber = ((CurrentFileNumber-1.5)%tablelength(PathList))+0.5
	vis:command('e ' .. PathList[CurrentFileNumber])
end, 'Switch to preivous file in file list')

vis:command_register('bd', function(argv, force, win, cursor, range)
	if PathList[CurrentFileNumber] == vis.win.file.path then
		table.remove(PathList, CurrentFileNumber)
		table.remove(NameList, CurrentFileNumber)
		--if (CurrentFileNumber == tablelength(PathList)) then
			--vis:command('e ' .. PathList[tablelength(PathList) - 1])
			--CurrentFileNumber = CurrentFileNumber - 1
		--else
			--vis:command('e ' .. PathList[CurrentFileNumber + 1])
		--end
	end
end, 'Remove current file from file list')

-- Make NameList readable from other files, for instance in a statusline script
local FileList = {}
FileList.Names = NameList
return FileList

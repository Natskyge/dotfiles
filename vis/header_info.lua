-- Created:  Thu 12 May 2016
-- Modified: Mon 17 Jul 2017
-- Author:   Josh Wainwright
-- Filename: header_info.lua

local header_info = {}

header_info.LINES = 4
header_info.AUTHOR = 'Josh Wainwright'

local get_info = function(file, comment)
	local str =    'Created:  ' .. os.date('%a %d %b %Y') .. '\n' ..
		comment .. 'Modified: ' .. os.date('%a %d %b %Y') .. '\n' ..
		comment .. 'Author:   ' .. header_info.AUTHOR .. '\n' ..
		comment .. 'Filename: ' .. file.name .. '\n'
	return str
end

local header_insert = function(win)
	local cur_line = win.file.lines[win.selection.line]
	local comment = string.match(cur_line, '^([^%s]+%s)')
	local str = get_info(win.file, comment or '')
	local cur_pos = win.selection.pos
	win.file:insert(cur_pos, str)
end

local function update(win)
	local fname = win.file.name
	if not fname then return end
	local save_line, save_col = win.selection.line, win.selection.col
	local check_line = function(i)
		local line = win.file.lines[i]
		if not line then return end
		local match = line:match('^(.*Modified:[%s]+)') or
						line:match('^(.*Created:%s+)TST')
		if match then
			local newline = match .. os.date('%a %d %b %Y')
			if newline ~= line then
				win.file.lines[i] = match .. os.date('%a %d %b %Y')
			end
		end
	end

	for i=1, header_info.LINES, 1 do
		check_line(i)
	end
	local len = #win.file.lines
	for i=len, len - header_info.LINES, -1 do
		check_line(i)
	end
	win.selection:to(save_line, save_col)
	--win.file.modified = false -- Not currently writable
end

vis:map(vis.modes.INSERT, '<M-C-I>', function() header_insert(vis.win) end)

vis:command_register('HeaderInfo', function(argv, force, win, selection, range)
	header_info.update(win)
end)

vis.events.subscribe(vis.events.WIN_OPEN, update)

return header_info

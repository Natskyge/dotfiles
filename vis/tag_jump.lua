-- Created:  Fri 13 May 2016
-- Modified: Wed 22 Mar 2017
-- Author:   Josh Wainwright
-- Filename: tag_jump.lua

word_at_pos = function(line, pos)
	local word_end = line:match('[%w_]+', pos + 1) or ''

	local rev_cur_pos = line:len() - pos + 1
	local word_start = line:reverse():match('[%w_]+', rev_cur_pos) or ''

	local word = word_start:reverse() .. word_end
	return word
end

vis:map(vis.modes.NORMAL, '<C-]>', function()
	local win = vis.win
	local line = win.file.lines[win.cursor.line]
	local word = word_at_pos(line, win.cursor.col)
	local tags_f = assert(io.open(os.getenv('PWD') .. '/tags', 'r'))
	local tag_line = ""
	for line in tags_f:lines() do
		local match = line:find('^' .. word)
		if match then
			tag_line = line
			break
		end
	end
	local tagname, tagfile, tagaddress = tag_line:match('([^\t]+)\t([^\t]+)\t([^\t]+)')
	if not tagname or not tagfile or not tagaddress then
		vis:info('Tag not found: ' .. word)
		return
	end
	tagaddress = tagaddress:sub(1,-3)
	tagaddress = tagaddress:gsub('([()])', '\\%1')
	vis:info('TagJump: ' .. tagname .. ' | ' .. tagfile .. ' | ' .. tagaddress)
	vis:command('e ' .. tagfile)
	vis:feedkeys(tagaddress .. 'G')
end)

local function showtags(argv, force, win, cursor, range)
	local fname = win.file.name
	local path = win.file.path

	local cmd = 'ctags --output-format=xref --_xformat="%l\t%k\t%n\t%N" --sort=no '
	cmd = cmd .. path
	
	local f = assert(io.popen(cmd, 'r'))
	local tags = assert(f:read('*a'))
	f:close()
	vis:message("")
	local msg_win = vis.win
	msg_win.file:delete(0, msg_win.file.size)
	msg_win.file:insert(0, tags)

	msg_win:map(vis.modes.NORMAL, '<Enter>', function()
		local line = msg_win.file.lines[msg_win.cursor.line]
		local lang, ttype, line, name = line:match('(%S+)\t(.)\t(%d+)\t(%S)')
		win.cursor:to(line, 1)
		if force then
			vis:command(':q')
		end
	end)
end
vis:command_register("ShowTags", showtags)
vis:map(vis.modes.NORMAL, '<C-]>', function()
	showtags(nil, true, vis.win, vis.win.cursor, nil)
end)

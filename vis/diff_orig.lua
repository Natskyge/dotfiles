-- Created:  2016-05-17
-- Modified: Mon 14 Aug 2017
-- Author:   Josh Wainwright
-- Filename: diff_orig.lua

--[[
vis:command_register('Diff', function()
	local win = vis.win
	if not win.file.name then return end

	local tmpname = os.tmpname()
	local tmp = assert(io.open(tmpname, 'w'))
	tmp:write(win.file:content(0, win.file.size))
	tmp:close()

	local diff_cmd = ('diff -u %s %s'):format(win.file.name, tmpname)
	local f = assert(io.popen(diff_cmd, 'r'))
	local diff_out = assert(f:read('*a'))
	f:close()
	os.remove(tmpname)

	if diff_out == '' then
		vis:info('No difference')
		return
	end
	vis:message('')
	local win = vis.win
	win.file:delete(0, vis.win.file.size)
	win.file:insert(0, diff_out)
	win.selection.pos = 0
	win.syntax = 'diff'
end, 'Diff the saved version of the current file.')
--]]

vis:command_register('Diff', function()
	local win = vis.win
	if not win.file.name then return end

	local range = {start=0, finish=win.file.size}
	local cmd = 'diff -u '..win.file.name..' -'
	local err, stdout, stderr = vis:pipe(win.file, range, cmd)

	if stderr then vis:info('Diff: '..stderr) end

	vis:command('new')
	local win = vis.win
	win.file:delete(0, vis.win.file.size)
	win.file:insert(0, stdout)
	win.selection.pos = 0
	win:set_syntax('diff')
end, 'Diff the saved version of the current file.')

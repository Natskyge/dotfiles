-- Created:  2016-05-12
-- Modified: Mon 17 Jul 2017
-- Author:   Josh Wainwright
-- Filename: fmt_tabs.lua

local fmt_space_tab = function(win, repl, width)
	local save_line, save_col = win.selection.line, win.selection.col
	local lines = {}
	for i=1, #win.file.lines do
		local line = win.file.lines[i]
		local indent, content = line:match('^(%s+)(.*)$')
		if indent then
			local spaces = string.rep(' ', width)
			indent = indent:gsub(spaces, '\t')
			indent = indent:gsub(' +\t', '\t')
			indent = indent:gsub('\t', repl)
			line = indent .. content
		end
		table.insert(lines, line)
	end
	local str = table.concat(lines, '\n')
	win.file:delete(0, win.file.size)
	win.file:insert(0, str)
	win.selection:to(save_line, save_col)
end

local fmt_trailing = function(win)
	local save_line, save_col = win.selection.line, win.selection.col
	local lines = {}
	for i=1, #win.file.lines do
		local line = win.file.lines[i]
		line = line:gsub('%s+$', '')
		table.insert(lines, line)
	end
	local str = table.concat(lines, '\n')
	win.file:delete(0, win.file.size)
	win.file:insert(0, str)
	win.selection:to(save_line, save_col)
end

local fmt_line_end = function(win, lineend)
	local save_line, save_col = win.selection.line, win.selection.col
	local lines = {}
	for i=1, #win.file.lines do
		local line = win.file.lines[i]
		table.insert(lines, line)
	end
	local str = table.concat(lines, lineend) .. lineend
	win.file:delete(0, win.file.size)
	win.file:insert(0, str)
	win.selection:to(save_line, save_col)
end

vis:command_register('Fmt', function(argv, force, win, selection, range)
	local cmd = argv[1]
	if not cmd then
		local s = win.file.size
		fmt_space_tab(win, '\t', 4)
		fmt_trailing(win)
		fmt_line_end(win, '\n')
		vis:info('Size difference: ' .. (win.file.size - s) .. ' bytes')
	elseif cmd == 'space' then
		local spaces = string.rep(' ', argv[2] or 4)
		fmt_space_tab(win, spaces, argv[2] or 4)
	elseif cmd == 'tab' then
		fmt_space_tab(win, '\t', argv[2] or 4)
	elseif cmd == 'trailing' then
		fmt_trailing(win)
	elseif cmd == 'nl' then
		fmt_line_end(win, '\n')
	elseif cmd == 'crnl' then
		fmt_line_end(win, '\r\n')
	end
end)

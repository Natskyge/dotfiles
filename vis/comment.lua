-- Created:  Thu 26 May 2016
-- Modified: Mon 17 Jul 2017
-- Author:   Josh Wainwright
-- Filename: comment.lua

local dict = {
	bash = '#',
	c = '//',
	conf = '#',
	cpp = '//',
	dosbatch = '::',
	dot = '//',
	gitconfig = '#',
	gnuplot = '#',
	haskell = '--',
	java = '//',
	lua = '--',
	mail = '> ',
	make = '#',
	markdown = '<!--',
	perl = '#',
	python = '#',
	ruby = '#',
	sh = '#',
	tex = '%',
	vim = '"',
	zsh = '#',
}

local toggle_comment = function(win)
	local syntax = win.syntax
	local selection = win.selection.selection
	local com_char = dict[syntax]
	if com_char ~= nil then
		--if selection then
		--	for line in selection do
		--		add comment char
		--	end
		--end
		local line, col = win.selection.line, win.selection.col
		win.file.lines[line] = com_char  .. ' ' .. win.file.lines[line]
		win.selection:to(line, col)
		--win:draw()
	else
		vis:info(syntax .. ': no comment char')
	end
end

vis:map(vis.modes.NORMAL, 'gcc', function() toggle_comment(vis.win) end)
vis:map(vis.modes.VISUAL, 'gc', function() toggle_comment(vis.win) end)

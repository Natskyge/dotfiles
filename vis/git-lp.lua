-- Created:  Wed 07 Dec 2016
-- Modified: Fri 21 Jul 2017
-- Author:   Josh Wainwright
-- Filename: git-lp.lua

local function capture(cmd)
	local f = assert(io.popen(cmd, 'r'))
	local s = assert(f:read('*a'))
	f:close()
	return s
end

local gitlp
local gitlp_log

gitlp_log = function(x, commits)
	local win = vis.win
	local fmt = '%h %<(14)%ar %s (%an)%d'
	local logcmd = 'git log --no-color -n 100 --pretty=format:"'..fmt..'"'
	local log = capture(logcmd)
	win.file:delete(0, win.file.size)
	win.file:insert(0, log)
	win.selection:to(1, 1)
	win:set_syntax('gitlog')
	vis:feedkeys('/'..commits[x]:sub(1,7)..'<Enter>')

	win:map(vis.modes.NORMAL, '<Enter>', function()
		local line = win.file.lines[win.selection.line]
		local hash = line:match('^.-(%x+)')
		for i=1, #commits do
			if commits[i]:sub(1, hash:len()) == hash then
				gitlp(i, commits)
				break
			end
		end
	end)
end

gitlp = function(x, commits)
	local win = vis.win
	local x = x or 1
	local commits = commits or nil
	if not commits then
		local com_str = capture('git rev-list master')
		commits = {}
		for i in com_str:gmatch('[^\n]+') do
			commits[#commits+1] = i
		end
		vis:info('Total commits: ' .. #commits)
		
		if #commits == 0 then
			vis:info('Not a git repository')
			return
		end
	end

	local c = x .. ' ' .. capture('git show --no-color --first-parent ' .. commits[x])

	if win.file.name ~= 'gitlp' then
		vis:command('e! gitlp')
	end
	local win = vis.win
	win.file:delete(0, win.file.size)
	win.file:insert(0, c)
	win:set_syntax('diff')
	win.selection:to(1,1)

	win:map(vis.modes.NORMAL, 'l', function()
		x = x + 1
		if x > #commits then x = #commits; return end
		gitlp(x, commits)
	end)
	win:map(vis.modes.NORMAL, 'h', function()
		x = x - 1
		if x < 1 then x = 1; return end
		gitlp(x, commits)
	end)
	win:map(vis.modes.NORMAL, 'gg', function()
		x = 1
		gitlp(x, commits)
	end)
	win:map(vis.modes.NORMAL, 'G', function()
		x = #commits
		gitlp(x, commits)
	end)
	win:map(vis.modes.NORMAL, 'q', function()
		vis:command('q!')
	end)
	win:map(vis.modes.NORMAL, '-', function()
		gitlp_log(x, commits)
	end)
	vis:feedkeys('<vis-redraw>')
end

vis:command_register('GitLP', function(argv, force, win, selection, range)
	gitlp()
end)

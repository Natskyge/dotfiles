-- Created:  Mon 16 May 2016
-- Modified: Mon 17 Jul 2017
-- Author:   Josh Wainwright
-- Filename: navd_p.lua

local function basename(path)
	if path:sub(-1,-1) == '/' then
		path = path:sub(1, -2)
	end
	local sl = path:reverse():find('/', 1, true)
	if not sl then
		return path
	end
	sl = path:len() - sl + 2
	return path:sub(sl)
end

local function dirname(path)
	if not path then
		return os.getenv('PWD')
	elseif path:sub(-1,-1) == '/' then
		return path:sub(1,-2)
	end
	local sl = path:reverse():find('/', 1, true)
	if not sl then
		return path
	end
	sl = path:len() - sl
	return path:sub(1, sl)
end

-- Open navd window
vis.navd = function(path, search)
	if vis.win.file.name and vis.win.file.modified then
		vis:info('No write since last change')
		return
	end
	local fname = vis.win.file.name
	if not path or path == '' then
		path = dirname(vis.win.file.path)
	end
	path = path:gsub('/+', '/')
	if not search then
		search = ""
		if fname then
			search = basename(fname)
		end
	end

	local lscmd = 'ls -1 -A -p -b --group-directories-first "' .. path .. '"'
	local f = assert(io.popen(lscmd, 'r'))
	local list = assert(f:read('*a'))
	f:close()
	list = list:gsub('\\ ', ' ')
	list = '# ' .. path .. '\n' .. list

	vis:message('')
	local win = vis.win
	win.file:delete(0, win.file.size)
	win.file:insert(0, list)
	win:set_syntax('diff')
	win.selection:to(1,1)

	vis:feedkeys('/' .. search .. '<Enter>')

	win:map(vis.modes.NORMAL, '<Enter>', function()
		local line = win.file.lines[win.selection.line]
		local file = path .. '/' .. line
		if line:sub(1,1) == '#' then return end
		if line:sub(-1) == '/' then
			vis.navd(file)
		else
			vis:feedkeys(':q<Enter>')
			vis:feedkeys(':e ' .. file .. '<Enter>')
		end
	end)

	win:map(vis.modes.NORMAL, '-', function()
		local path = win.file.lines[1]:gsub('^# ', ''):gsub('/$', '')
		local search = basename(path)
		local path = dirname(path) .. '/'
		vis.navd(path, search)
	end)

	win:map(vis.modes.NORMAL, 'q', function()
		vis:feedkeys(':q<Enter>')
	end)

	win:map(vis.modes.NORMAL, 'gh', function()
		vis.navd(os.getenv('HOME'))
	end)
end

vis:map(vis.modes.NORMAL, '-', vis.navd)

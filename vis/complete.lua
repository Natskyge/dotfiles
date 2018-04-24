-- Created:  Fri 16 Dec 2016
-- Modified: Tue 10 Oct 2017
-- Author:   Josh Wainwright
-- Filename: complete.lua
vis.compl = {}

local function print_matches(matches, current)
	local columns = vis.win.width
	local matches_str = table.concat(matches, '  ', 1, current-1)
	local current_match = ' |' .. matches[current] .. '| '
	matches_str = matches_str .. current_match
	if matches_str:len() > columns then
		matches_str = current_match
	end
	matches_str = matches_str .. table.concat(matches, '  ', current+1)
	vis:info(matches_str)
end

-------------------------------------------------------------------------------
-- Completion -----------------------------------------------------------------
-------------------------------------------------------------------------------
local function complete_generic(dir, get_matches, matchpat)
	local win = vis.win
	local file = win.file
	local curline = vis.win.selection.line
	local line = file.lines[curline]

	-- Reset completion matches because the text has changed
	if vis.compl.prevline ~= line then
		vis.compl.matches = nil
	end

	-- Get matches
	if vis.compl.matches == nil then
		local pre, pat = line:sub(1, win.selection.col-1):match('^'..matchpat..'$')
		local post = line:sub(win.selection.col)
		local patlen = pat:len()

		-- No pattern, so insert tab character
		if patlen == 0 then
			local replacement = pre .. pat .. '\t'
			local newline =  replacement .. post
			win.file.lines[curline] = newline
			win:draw()
			win.selection:to(curline, replacement:len() + 1)
			return
		end

		local matches = {pat}
		get_matches(matches, pat)

		vis.compl.matches = matches
		vis.compl.current = 1
		vis.compl.pre     = pre
		vis.compl.post    = post
	end

	-- Increment by 1 in the list of matches
	vis.compl.current = vis.compl.current + (dir or 1)
	if vis.compl.current == 0 then
		vis.compl.current = #vis.compl.matches
	elseif vis.compl.current > #vis.compl.matches then
		vis.compl.current = 1
	end

	local matches = vis.compl.matches
	local current = vis.compl.current

	print_matches(matches, current)

	-- Insert match into text
	local match = matches[current]
	local newline = vis.compl.pre .. match
	local col = newline:len() + 1
	newline = newline .. vis.compl.post
	win.file.lines[curline] = newline
	win:draw()
	win.selection:to(curline, col)

	vis.compl.prevline = newline
end

-- Complete File --------------------------------------------------------------
local function matches_file(matches, pat)
	local lfs = require('lfs')

	local dirname, basename = pat:match('(.*[\\/])([^\\/]*)$')
	local basenamelen = basename:len()

	local replace_tilde = false
	if dirname and dirname:sub(1,2) == '~/' then
		dirname = os.getenv('HOME') .. '/' .. dirname:sub(3)
		replace_tilde = true
	end

	for f in lfs.dir(dirname or '.') do
		if f ~= '.' and f ~= '..' then
			if f:sub(1, basenamelen) == basename then
				if lfs.attributes(dirname .. f, 'mode') == 'directory' then
					f = f .. '/'
				end
				if replace_tilde then
					dirname = dirname:gsub(os.getenv('HOME'), '~')
				end
				matches[#matches+1] = dirname .. f
			end
		end
	end
end

-- Complete Line --------------------------------------------------------------
local function matches_line(matches, pat_orig)
	local pat = pat_orig:gsub('^%s+', '')
	local patlen = pat:len()

	local curline = vis.win.selection.line
	local n = 0
	for line_orig in vis.win.file:lines_iterator() do
		n = n + 1
		local line = line_orig:gsub('^%s+', '')
		if n ~= curline and line:sub(1, patlen) == pat then
			matches[#matches+1] = line
		end
	end
end

-- Complete Dictionary --------------------------------------------------------
local function matches_dict(matches, pat)
	local dict_fname = '/usr/share/dict/words'
	local dict_f = io.open(dict_fname, 'r')
	if not dict_f then
		vis:info('No dictionary file found at '..dict_fname)
		return
	end
	local pat = pat:lower()
	local patlen = pat:len()
	for line in dict_f:lines() do
		if line:len() > patlen and line:sub(1, patlen) == pat then
			matches[#matches+1] = line
		end
	end
	dict_f:close()
end

-- Complete Word --------------------------------------------------------------
local function matches_word(matches, pat)
	local start_num_matches = #matches

	local patlen = pat:len()
	local found = {}

	local function line_get_matches(line)
		for word in line:gmatch('[%w_]+') do
			if not found[word]
				and word:len() > patlen
				and word:sub(1, patlen) == pat
			then
				found[word] = true
				matches[#matches+1] = word
			end
		end
	end

	local file = vis.win.file
	local curline = vis.win.selection.line

	-- Get matches from current line backwards to start of file ...
	for l=curline-1, 1, -1 do
		local line = file.lines[l]
		if line_get_matches(line) then return end
	end

	-- ... then from end of file to current line
	for l=#file.lines, curline, -1 do
		local line = file.lines[l]
		if line_get_matches(line) then return end
	end

	if #matches == start_num_matches then
		matches_dict(matches, pat)
	end
end

-- Complete Command -----------------------------------------------------------
local cmds = {
	'bdelete ',
	'cd ',
	'earlier ',
	'help',
	'langmap ',
	'later ',
	'map ',
	'map-window ',
	'new',
	'open ',
	'qall',
	'set ',
		'set shell',
		'set escdelay',
		'set autoindent',
		'set expandtab',
		'set tabwidth',
		'set theme',
		'set syntax',
		'set show-',
			'set show-spaces',
			'set show-tabs',
			'set show-newlines',
		'set numbers',
		'set relativenumbers',
		'set cursorline',
		'set colorcolumn',
		'set horizon',
		'set savemethod',
	'split ',
	'unmap ',
	'unmap-window '
}
local function matches_cmd(matches, pat)
	local pat = pat:lower()
	local patlen = pat:len()

	for i, cmd in ipairs(cmds) do
		if cmd:sub(1, patlen) == pat then
			matches[#matches+1] = cmd
		end
	end
end

-- Smart Tab Completion -------------------------------------------------------
local function smart_tab(dir)
	local win = vis.win
	if #win.selections > 1 then
		vis:feedkeys('<vis-selections-align-indent-left>')
		return
	end
	local file = win.file
	local line = file.lines[win.selection.line]

	if file.name == nil and line:sub(1,1) == ':' then
		complete_generic(dir, matches_cmd, '(.)(.*)')

	--elseif line:sub(1, win.selection.col):match('%S+/%S+$') then
	--	complete_generic(dir, matches_file, '(.-)(%S*)')

	else
		complete_generic(dir, matches_word, '(.-)([%w_]*)')
	end
end

vis:map(vis.modes.INSERT, '<Tab>', function() smart_tab(1) end)
vis:map(vis.modes.INSERT, '<S-Tab>', function() smart_tab(-1) end)

vis:map(vis.modes.INSERT, '<C-x><C-l>', function()
	complete_generic(dir, matches_line, '(%s*)(.*)')
end, 'Complete line')

vis:map(vis.modes.INSERT, '<C-x><C-f>', function()
	complete_generic(dir, matches_file, '(.-)(%S*)')
end, 'Complete file')

vis:map(vis.modes.INSERT, '<C-x><C-n>', function()
	complete_generic(dir, matches_word, '(.-)([%w_]*)')
end, 'Complete from buffer')

vis:map(vis.modes.INSERT, '<C-x><C-s>', function()
	complete_generic(dir, matches_dict, '(.-)([%w_]*)')
end, 'Complete from dictionary')

vis:map(vis.modes.INSERT, '<C-x><C-c>', function()
	complete_generic(dir, matches_cmd, '(.-)(%S*)')
end, 'Complete command')

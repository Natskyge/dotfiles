-- Created:  Wed 25 May 2016
-- Modified: Wed 19 Jul 2017
-- Author:   Josh Wainwright
-- Filename: toggle.lua

local mods = {
	{ 'true', 'false' },
	{ 'yes', 'no' } ,
	{ 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday',
		'sunday' },
	{ 'january', 'february', 'march', 'april', 'mayy', 'june', 'july',
		'august', 'september', 'october', 'november', 'december' }
}

local index = function(tbl, value)
	for i, j in ipairs(tbl) do
		if j == value then return i end
	end
	return nil
end

local function replace_word(line, col, word, replace)
	local start = col - string.len(word)
	if start < 0 then start = 0 end
	local idx_s, idx_e = string.find(line, word, start, true)
	local after = line:sub(idx_s + string.len(word), -1)
	local newline, newcol
	if idx_s == 1 then
		newline = replace .. after
		newcol = newline:len()
	else
		before = line:sub(1, idx_s - 1)
		newline = before .. replace
		newcol = newline:len()
		newline = newline .. after
	end
	return newline, newcol
end

local function increment_word(word, direction)
	if not word then return end

	local number = tonumber(word)
	if number then
		return tostring(number + direction)
	end

	local retval = ''
	local w = string.lower(word)
	for _, lst in pairs(mods) do
		local idx = index(lst, w)
		if idx ~= nil then
			local newidx = ((idx-1 + direction) % #lst) + 1
			retval = lst[newidx]
			if string.match(word, '^%l*$') then
				-- No change needed
			elseif string.match(word, '^%u*$') then
				retval = string.upper(retval)
			elseif string.match(word, '^%u%l*$') then
				retval = string.upper(retval:sub(1, 1)) .. retval:sub(2, -1)
			else
				return nil
			end
			return retval
		end
	end
end

local function cword(win, cursor)
	local line = win.file.lines[cursor.line]
	local col = cursor.col
	local char = line:sub(col, col)

	-- Check if on whitespace, return nothing
	if char:match('%s') then return nil end

	local word_pat_for = '[%w_]+'
	local word_pat_bac = '[%w_]+%-?'
	if char:match('%d') then
		word_pat_for = '%d+'
		word_pat_bac = '%d+%-?'
	end

	local word_end = line:match(word_pat_for, col) or ''

	local rev_cur_pos = line:len() - col + 1
	local word_start = line:reverse():match(word_pat_bac, rev_cur_pos) or ''

	return word_start:reverse() .. word_end:sub(2, -1)
end

local function incr(win, dir)
	for selection in win:selections_iterator() do
		local arg = cword(win, selection)
		local newword = increment_word(arg, (vis.count or 1) * dir)
		if newword then
			local linenr = selection.line
			local line = win.file.lines[linenr]
			local newline, newcol = replace_word(line, selection.col, arg, newword)
			win.file.lines[linenr] = newline
			selection:to(linenr, newcol)
		end
	end
	vis.count = nil
end

vis:map(vis.modes.NORMAL, '<C-a>', function() incr(vis.win, 1) end)
vis:map(vis.modes.NORMAL, '<C-x>', function() incr(vis.win, -1) end)

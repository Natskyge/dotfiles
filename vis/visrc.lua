-- load standard vis module, providing parts of the Lua API
require('vis')

require('navd_p')
require('tag_jump')
require('reg_save')
require('fmt_tabs')
require('statusline')
require('header_info')
require('diff_orig')
require('toggle')
require('comment')
require('git-lp')
require('complete')
require('file_list')
require('fzf-open')

vis.events.subscribe(vis.events.INIT, function()
	-- enable syntax highlighting for known file types
	require('plugins/filetype')

	vis:command('set theme base16-materia')
	vis:command('set escdelay 10')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	vis:command('set number on')
	vis:command('set tabwidth 4')
	vis:command('set autoindent on')
	vis:command('set colorcolumn 81')
	vis:command('set show-tabs on')

	--local fmt = "\x1b]2;%s/[%s]\x07\n"
	--local pwd = os.getenv('PWD'):gsub(os.getenv('HOME'), '~')
	--io.write(fmt:format(pwd, vis.win.file.name or '.'))
end)

vis:map(vis.modes.NORMAL, ' ', '<vis-prompt-show>')
--vis:map(vis.modes.NORMAL, 'S', '<vis-insert-newline>')
vis:map(vis.modes.NORMAL, '<C-Up>', 'ddkP')
vis:map(vis.modes.NORMAL, '<C-Down>', 'ddp')

vis:map(vis.modes.INSERT, '<C-e>', '<vis-motion-line-end>')
vis:map(vis.modes.INSERT, '<C-a>', '<vis-motion-line-start>')
vis:map(vis.modes.INSERT, '<C-Right>', '<vis-motion-word-start-next>')
vis:map(vis.modes.INSERT, '<C-Left>', '<vis-motion-word-start-prev>')

vis:option_register('makeprg', 'string', function(value)
	if not vis.win then return false end
	vis.win.makeprg = value
	vis:info('Option makeprg = ' .. tostring(vis.win.makeprg))
	return true
end, 'Set the program to run when invoking make')

vis:command_register('make', function(argv, force, win, cursor, range)
	if vis.win then vis:command('w') end
	local cmd = vis.win.makeprg or 'ninja -v'
	local tmpname = os.tmpname()
	local success = os.execute(cmd..' 2>&1 | tee '..tmpname..'; (exit ${PIPESTATUS[0]})')
	if not success then
		local f = assert(io.open(tmpname, 'r'))
		local output = f:read('*all')
		f:close()
		os.remove(tmpname)
		vis:message('')
		local win = vis.win
		win.file:delete(0, win.file.size)
		win.file:insert(0, output)
		vis.win:map(vis.modes.NORMAL, 'q', function() vis:command('q!') end)
	else
		vis:feedkeys('<vis-redraw>')
		vis:info('Exit success: '..cmd)
	end
end, 'Run the command specified by makeprg (defaults to make)')

vis:map(vis.modes.NORMAL, '<F5>', function()
	vis:command('make')
end, 'Run make in current directory')

vis:map(vis.modes.NORMAL, '[ ', function()
	for i=1, (vis.count or 1) do
		vis:feedkeys('<vis-mark>am<vis-motion-line-begin><vis-insert-newline><vis-mark>aM')
	end
end, 'Insert newline above current line')

vis:map(vis.modes.NORMAL, '] ', function()
	for i=1, (vis.count or 1) do
		vis:feedkeys('<vis-mark>am<vis-motion-line-end><vis-insert-newline><vis-mark>aM')
	end
end, 'Insert newline below current line')

vis:command_register('setf', function(argv, force, win, cursor, range)
	vis:command('set syntax ' .. (argv[1] or ''))
end, 'Alias for set syntax ...')

vis:command_register('pwd', function(argv, force, win, cursor, range)
	vis:info(('%s/[%s]'):format(win.file.path, win.file.name))
end, 'Display present working directory and filename')

function plumber(input)
	local fileType = input:match("^.*%|(.*)")
	local command = ''

	if fileType == '' then
		command = assert(io.popen(input))
	else
		command = assert(io.popen(input))
	end

	local output = command:read('*a')
	command:close()
	return output
end

vis:operator_new('gs', function(file, range, pos)
	local text = file:content(range)
	local output = plumber(text)
	file:delete(range)
	file:insert(range.start, output)
	return range.start
end, 'Send selection to plumber and print output')

-- Navd - Navigate Directories
--      Colours for displaying folders

local l = require('lexer')
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'navd'}

M._LEXBYLINE = true

-- Comments.
local comment = token(l.COMMENT, '#' * l.nonnewline_esc^0)

-- Folder
local folder = token(l.FUNCTION, (l.any - P('/'))^0 * P('/')^1)

M._rules = {
  {'comment', comment},
  {'folder', folder},
}

return M

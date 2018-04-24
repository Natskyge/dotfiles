-- Ninja LPeg lexer.

local l = require('lexer')
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'conf'}

-- Comments.
local comment = token(l.COMMENT, '#' * l.nonnewline^0)

-- Numbers.
local number = token(l.NUMBER, l.float + l.integer)

-- Strings.
local sq_str = l.delimited_range("'", true)
local dq_str = l.delimited_range('"', true)
local string = token(l.STRING, sq_str + dq_str)

M._rules = {
  {'comment', comment},
  {'number', number},
  {'string', string},
}

return M
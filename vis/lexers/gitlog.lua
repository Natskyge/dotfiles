-- Git Log LPeg lexer.

local l = require('lexer')
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'gitlog'}

-- Hash
local hash = token(l.VARIABLE, l.xdigit^7)

local date = token(l.FUNCTION,
		l.digit^1 *
		l.space^1 *
		l.word_match({'days', 'weeks', 'months'}) *
		l.space^1 *
		P('ago')
)

local author = token(l.COMMENT, 
	l.delimited_range('(', true, true, true) *
	l.newline
)

M._rules = {
  {'hash', hash},
  {'date', date},
  {'author', author},
}

M._LEXBYLINE = true

return M

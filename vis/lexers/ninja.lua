-- Ninja LPeg lexer.

local l = require('lexer')
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'ninja'}

-- Whitespace.
local ws = token(l.WHITESPACE, l.space^1)

-- Comments.
local comment = token(l.COMMENT, '#' * l.nonnewline^0)

-- Variables.
local variable = token(l.VARIABLE,
	'$' * (l.digit + l.word + l.delimited_range('{}', true))
)

-- Strings.
local sq_str = l.delimited_range("'", true)
local dq_str = l.delimited_range('"', true)
local string = token(l.STRING, sq_str + dq_str) + variable

-- Numbers.
local number = token(l.NUMBER, l.float + l.integer)

-- Keyword.
local keyword = token(l.KEYWORD,
	(word_match{'command', 'depfile', 'deps', 'depth', 'description', 
		'generator', 'in', 'in_newline', 'msvc_deps_prefix', 'out', 'pool', 
		'restat', 'rspfile', 'rspfile_content'} * S('\t ')^0 * '=') + 
	P('phony')
)

-- Functions.
local functions = token(l.FUNCTION, l.starts_line(
	word_match{'build', 'default', 'include', 'pool', 'rule', 'subninja'}
) * S('\t ')^0 )

local rule = ''

-- Operators.
local line_continue = P('$') * #l.newline
local operator = token(l.OPERATOR, S('=:|') + line_continue )

M._rules = {
  {'whitespace', ws},
  {'keyword', keyword},
  {'function', functions},
  {'variable', variable},
  {'string', string},
  {'comment', comment},
  {'number', number},
  {'operator', operator},
}

return M
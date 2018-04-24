local l = require('lexer')
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'default-groups'}

local t_default = token(l.DEFAULT, P('_DEFAULT '))
local t_class = token(l.CLASS, P('_CLASS '))
local t_comment = token(l.COMMENT, P('_COMMENT '))
local t_constant = token(l.CONSTANT, P('_CONSTANT '))
local t_definition = token(l.DEFINITION, P('_DEFINITION '))
local t_error = token(l.ERROR, P('_ERROR '))
local t_function = token(l.FUNCTION, P('_FUNCTION '))
local t_keyword = token(l.KEYWORD, P('_KEYWORD '))
local t_label = token(l.LABEL, P('_LABEL '))
local t_number = token(l.NUMBER, P('_NUMBER '))
local t_operator = token(l.OPERATOR, P('_OPERATOR '))
local t_regex = token(l.REGEX, P('_REGEX '))
local t_string = token(l.STRING, P('_STRING '))
local t_preprocessor = token(l.PREPROCESSOR, P('_PREPROCESSOR '))
local t_tag = token(l.TAG, P('_TAG '))
local t_type = token(l.TYPE, P('_TYPE '))
local t_variable = token(l.VARIABLE, P('_VARIABLE '))
local t_whitespace = token(l.WHITESPACE, P('_WHITESPACE '))
local t_embedded = token(l.EMBEDDED, P('_EMBEDDED '))
local t_identifier = token(l.IDENTIFIER, P('_IDENTIFIER '))
local t_linenumber = token(l.LINENUMBER, P('_LINENUMBER '))
local t_cursor = token(l.CURSOR, P('_CURSOR '))
local t_cursor_primary = token(l.CURSOR_PRIMARY, P('_CURSOR_PRIMARY '))
local t_cursor_line = token(l.CURSOR_LINE, P('_CURSOR_LINE '))
local t_color_coloumn = token(l.COLOR_COLOUMN, P('_COLOR_COLOUMN '))
local t_selection = token(l.SELECTION, P('_SELECTION '))

M._rules = {
	{'default', t_default},
	{'class', t_class},
	{'comment', t_comment},
	{'constant', t_constant},
	{'definition', t_definition},
	{'error', t_error},
	{'function', t_function},
	{'keyword', t_keyword},
	{'label', t_label},
	{'number', t_number},
	{'operator', t_operator},
	{'regex', t_regex},
	{'string', t_string},
	{'preprocessor', t_preprocessor},
	{'tag', t_tag},
	{'type', t_type},
	{'variable', t_variable},
	{'whitespace', t_whitespace},
	{'embedded', t_embedded},
	{'identifier', t_identifier},
	{'linenumber', t_linenumber},
	{'cursor', t_cursor},
	{'cursor_primary', t_cursor_primary},
	{'cursor_line', t_cursor_line},
	{'color_coloumn', t_color_coloumn},
	{'selection', t_selection},
}

return M
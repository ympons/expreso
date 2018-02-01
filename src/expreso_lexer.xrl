Definitions.

VAR   = ([A-Za-z_][0-9a-zA-Z_]*)
INT   = [-+]?[0-9]+
FLOAT = [-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?
COMP  = (<|<=|=|>=|>|!=)
ADD   = (\+|\-)
MULT  = (\*|/|mod)
STR   = '[^'\n]*'
WS    = ([\000-\s]|%.*)

Rules.

false   : {token, {false,   TokenLine}}.
true    : {token, {true,    TokenLine}}.
in      : {token, {in_op,   TokenLine, list_to_atom(TokenChars)}}.
or      : {token, {or_op,   TokenLine, list_to_atom(TokenChars)}}.
and     : {token, {and_op,  TokenLine, list_to_atom(TokenChars)}}.
not     : {token, {not_op,  TokenLine, list_to_atom(TokenChars)}}.
{COMP}  : {token, {comp_op, TokenLine, list_to_atom(TokenChars)}}.
{ADD}   : {token, {add_op,  TokenLine, list_to_atom(TokenChars)}}.
{MULT}  : {token, {mult_op, TokenLine, list_to_atom(TokenChars)}}.
{VAR}   : {token, {var,     TokenLine, list_to_binary(TokenChars)}}.
{STR}   : {token, {string,  TokenLine, list_to_binary(strip(TokenChars, TokenLen))}}.
{INT}   : {token, {number,  TokenLine, list_to_integer(TokenChars)}}.
{FLOAT} : {token, {number,  TokenLine, list_to_float(TokenChars)}}.
[(),]   : {token, {list_to_atom(TokenChars), TokenLine}}.
{WS}+   : skip_token.

Erlang code.

strip(TokenChars,TokenLen) ->
    lists:sublist(TokenChars, 2, TokenLen - 2).

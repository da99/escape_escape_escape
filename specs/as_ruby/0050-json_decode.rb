
it     'strips unprintable chars'
input  %^["a\u2029\u2028"]^
output ["a"]

it     'raises Oj::ParseError if invalid JSON:'
input   'a'
raises Oj::ParseError, /unexpected character/

it     'raises Invalid if not a String:'
input  1
raises Escape_Escape_Escape::Invalid, /1/

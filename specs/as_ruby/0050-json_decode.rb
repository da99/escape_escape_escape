
it     'strips unprintable chars'
input  %^["a\u2029\u2028"]^
output ["a"]

it     'raises Invalid if invalid JSON:'
input   'Object.new'
raises Escape_Escape_Escape::Invalid, /invalid/

it     'raises Invalid if not a String:'
input  1
raises Escape_Escape_Escape::Invalid, /1/

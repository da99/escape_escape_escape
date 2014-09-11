

it     'returns string if valid'
input  '-moz-def'
output '-moz-def'


it     'raises Invalid if it contains unallowed chars:'
input  'moz def'
raises Escape_Escape_Escape::Invalid, /contains invalid chars/

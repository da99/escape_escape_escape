

it     'returns string if valid'
input  '#my_box div.hello:hover'
output '#my_box div.hello:hover'


it     'raises Invalid if it contains unallowed chars:'
input  '$my_box'
raises Escape_Escape_Escape::Invalid, /contains invalid chars/



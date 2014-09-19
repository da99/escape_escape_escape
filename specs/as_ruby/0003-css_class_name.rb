

it     'raises Invalid if has invalid chars:'
input  'k k'
raises Escape_Escape_Escape::Invalid, /k k/


it     'raises Invalid if has invalid chars:'
input  'k&amp;k'
raises Escape_Escape_Escape::Invalid, /k&amp;k/


it      'returns String if valid:'
input   'my_name'
output  'my_name'


it       'raises Invalid if it contains a dash:'
input    'my-name'
raises   Escape_Escape_Escape::Invalid, /my-name/







it     'raises Invalid if it has invalid chars:'
input  'a*'
raises Escape_Escape_Escape::Invalid, /a\*/


it      'returns a Symbol if a String is passed:'
input   'a'
output  :a


it      'returns a Symbol if a Symbol is passed:'
input   :a
output  :a


it      'downcases if passed a String:'
input   'My_Id'
output  :my_id


it      'downcases if passed a Symbol:'
input   :My_Id
output  :my_id


it       'raises Invalid if it begins with a number'
input    '0a'
raises    Escape_Escape_Escape::Invalid, /0a/


it        'raises Invalid if it contains a dash'
input     'my-id'
raises    Escape_Escape_Escape::Invalid, /my-id/






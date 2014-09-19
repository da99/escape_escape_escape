

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




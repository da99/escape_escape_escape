
it     'raises Invalid if it encounters an unallowed Object'
input  [Object.new]
raises Escape_Escape_Escape::Invalid, /object/


it     'raises Invalid if not an Array:'
input( {'a'=>'hello'} )
raises Escape_Escape_Escape::Invalid, /Hash/


it     'raises Invalid if not an Array:'
input  'a'
raises Escape_Escape_Escape::Invalid, /String/


it     'raises Invalid if not an Array:'
input  1
raises Escape_Escape_Escape::Invalid, /FixNum/

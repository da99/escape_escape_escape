
it     'raises TypeError if it encounters an unallowed Object'
input  [Object.new]
raises TypeError, /Failed to dump Object Object/


it     'raises Invalid if not an Array:'
input( {'a'=>'hello'} )
raises Escape_Escape_Escape::Invalid, /Not an Array/


it     'raises Invalid if not an Array:'
input  'a'
raises Escape_Escape_Escape::Invalid, /Not an Array/


it     'raises Invalid if not an Array:'
input  1
raises Escape_Escape_Escape::Invalid, /Not an Array: 1/

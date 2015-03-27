
it     'raises TypeError if it encounters an unallowed Object'
input( {'a'=>Object.new} )
raises TypeError, /Failed to dump Object Object/


it     'raises Invalid if not a Hash:'
input( [{'a'=>'hello'}] )
raises Escape_Escape_Escape::Invalid, /Not an object\/hash/


it     'raises Invalid if not a Hash:'
input  'a'
raises Escape_Escape_Escape::Invalid, /Not an object\/hash/


it     'raises Invalid if not an Hash:'
input  1
raises Escape_Escape_Escape::Invalid, /Not an object\/hash/

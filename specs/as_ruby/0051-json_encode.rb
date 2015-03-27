
it     'raises TypeError if it encounters an unallowed Object'
input( {'a'=>Object.new} )
raises ArgumentError, /Unknown Class for json:/


it     'raises Invalid if not a Hash:'
input( [{'a'=>'hello'}] )
raises Escape_Escape_Escape::Invalid, /Not an object\/hash/


it     'raises Invalid if not a Hash:'
input  'a'
raises Escape_Escape_Escape::Invalid, /Not an object\/hash/


it     'raises Invalid if not an Hash:'
input  1
raises Escape_Escape_Escape::Invalid, /Not an object\/hash/


it     'turns Symbol keys and values into Strings'
input(  {:a=>:c}  )
output  '{"a":"c"}'


it     'allows True/False as values'
input(  {:a=>true, :b=>false}  )
output  '{"a":true,"b":false}'

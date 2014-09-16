
it     'strips unprintable chars'
input  %^["a\u2029\u2028b"]^
output ["ab"]


it     'raises Oj::ParseError if invalid JSON:'
input   'a'
raises Oj::ParseError, /unexpected character/


it     'raises Invalid if not a String:'
input  1
raises Escape_Escape_Escape::Invalid, /1/


it     'uses :strict_load'
input  Oj.dump(Object.new, :mode=>:object)
output({"^o" => "Object"})

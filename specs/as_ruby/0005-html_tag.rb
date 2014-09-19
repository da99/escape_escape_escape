


it     "raises Invalid if tag has invalid chars:"
input  "a("
raises Escape_Escape_Escape::Invalid, /a\(/


it      "raises Invalid if tag starts w/ Numeric:"
input   '9a'
raises  Escape_Escape_Escape::Invalid, /9a/


it      "allows numbers:"
input   :a9
output  :a9


it      "allows underscores:"
input   :a_a
output  :a_a


it      "downcases the tag:"
input   "DiV"
output  :div

it      "downcases the tag:"
input   :DiV
output  :div


it      "returns a Symbol if passed a Symbol:"
input   :footer
output  :footer


it      "returns a Symbol if passed a String:"
input   'footeR'
output  :footer




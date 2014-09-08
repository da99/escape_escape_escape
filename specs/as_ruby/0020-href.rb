it     "returns nil if scheme is whitespace padded:"
input  "javascript ://alert()"
output nil

it     "returns nil if scheme is whitespace padded, slash encoded:"
input  "javascript :&sOL;/alert()"
output nil

it     "returns nil if colon encode:"
input  "javascript&#058;//alert()"
output nil

it     "returns nil if string is whitespace padded:"
input  "   javascript://alert()  "
output nil

it     "returns nil if string is whitespace padded, multi-case:"
input  "   javaSCript ://alert()  "
output nil




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


it     "escapes  valid /path"
input  "/path/mine/&"
output "/path/mine/&amp;"


it    "sets nil if invalid uri:"
input "javascript:alert(s)"
output nil

it    "sets nil any keys ending with _#{k} and have invalid uri"
input "javascript:alert(s)"
output nil

it     "escapes valid https uri"
input  "https://www.yahoo.com/&"
output "https://www.yahoo.com/&amp;"


it     "escapes valid uri"
input  "http://www.yahoo.com/&"
output "http://www.yahoo.com/&amp;"


it     "escapes valid /path:" do
input  "/path/mine/&"
output "/path/mine/&amp;"


it     "allows unicode uris"
input  "http://кц.рф"
output "http://&#x43a;&#x446;.&#x440;&#x444;"




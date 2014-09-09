

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
output "&#47;path&#47;mine&#47;&amp;"


it    "sets nil if invalid uri:"
input "javascript:alert(s)"
output nil

it    "sets nil if invalid uri"
input "javascript:alert(s)"
output nil

it     "escapes valid https uri"
input  "https://www.yahoo.com/&"
output "https:&#47;&#47;www.yahoo.com&#47;&amp;"


it     "escapes valid uri"
input  "http://www.yahoo.com/&"
output "http:&#47;&#47;www.yahoo.com&#47;&amp;"


it     "escapes valid relative path:"
input  "/path/mine/&"
output "&#47;path&#47;mine&#47;&amp;"


it     "returns nil if unicode uris:"
input  "http://кц.рф"
output nil


it    'normalizes address:'
input "hTTp://wWw.test.com/"
output "http:&#47;&#47;wWw.test.com&#47;"


it     'returns nil if invalid uri: < :'
input  "http://www.test.com/<something/"
output nil


it     'returns html escaped chars: \' :'
input  "http://www.test.com/?test='something/"
output "http:&#47;&#47;www.test.com&#47;?test=&#39;something&#47;"


it    'returns nil if HTML entities in uri:'
input "http://6&#9;6.000146.0x7.147/"
output nil


it      'returns nil if path contains html entities:'
input   "http://www.test.com/&nbsp;s/"
output  nil


it     'returns nil if query string contains HTML entities:'
input  "http://www.test.com/s/test?t&nbsp;test"
output nil



it     'does not re-escaped already escaped :href'
input  "http:&#47;&#47;www.example.com&#47;"
output "http:&#47;&#47;www.example.com&#47;"

it     'lower-cases scheme'
input  "hTTp://www.example.com/"
output "http:&#47;&#47;www.example.com&#47;"

it    'returns nil if contains &sol;, regardless of case:'
input  "htTp:&soL;&sOl;file.com/img.png"
output nil





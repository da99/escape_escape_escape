

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


it    'normalizes address'
input "hTTp://wWw.test.com/"
output "http://wWw.test.com/"


it     'returns html escaped chars: <'
input  "http://www.test.com/<something/"
output "http:&#47;&#47;www.test.com&#47;&lt;something&#47;"

it     'returns html escaped chars:'
input  "http://www.test.com/?test='something/"
output "http:&#47;&#47;www.test.com&#47;?test=&#39;something&#47;"


it    'decodes HTML entities:'
input "http://6&#9;6.000146.0x7.147/"
output "http:&#47;&#47;6\t6.000146.0x7.147&#47;"


it      'returns an encoded string if it contains HTML entities:'
input   "http://www.test.com/&nbsp;s/"
output  "http:&#47;&#47;www.test.com&#47;%C2%A0s&#47;"


it     'returns an HTML encode string if query string contains HTML entities:'
input  "http://www.test.com/s/test?t&nbsp;test"
output "http:&#47;&#47;www.test.com&#47;s&#47;test?t%C2%A0test"




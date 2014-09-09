

it     "raises Invalid_HREF if scheme is whitespace padded:"
input  "javascript ://alert()"
raises Escape_Escape_Escape::Invalid_HREF, /javascript/


it     "raises Invalid_HREF if scheme is whitespace padded, slash encoded:"
input  "javascript :&sOL;/alert()"
raises Escape_Escape_Escape::Invalid_HREF, /javascript/


it     "raises Invalid_HREF if colon encode: &#058; :"
input  "javascript&#058;//alert()"
raises Escape_Escape_Escape::Invalid_HREF, /javascript/


it     "raises Invalid_HREF if colon encode: &#x03a; :"
input  "javascript&#x03a;//alert()"
raises Escape_Escape_Escape::Invalid_HREF, /javascript/


it     "raises Invalid_HREF if colon encode: &#x03A; :"
input  "javascript&#x03A;//alert()"
raises Escape_Escape_Escape::Invalid_HREF, /javascript/


it     "raises Invalid_HREF if string is whitespace padded:"
input  "   javascript://alert()  "
raises Escape_Escape_Escape::Invalid_HREF, /javascript/


it     "raises Invalid_HREF if string is whitespace padded, multi-case:"
input  "   javaSCript ://alert()  "
raises Escape_Escape_Escape::Invalid_HREF, /javaSCript/i


it     "escapes  valid /path"
input  "/path/mine/&"
output "&#47;path&#47;mine&#47;&amp;"


it    "raises Invalid_HREF if invalid uri:"
input "javascript:alert(s)"
raises Escape_Escape_Escape::Invalid_HREF, /javascript/

it    "raises Invalid_HREF if invalid uri"
input "javascript:alert(s)"
raises Escape_Escape_Escape::Invalid_HREF, /javascript/

it     "escapes valid https uri"
input  "https://www.yahoo.com/&"
output "https:&#47;&#47;www.yahoo.com&#47;&amp;"


it     "escapes valid uri"
input  "http://www.yahoo.com/&"
output "http:&#47;&#47;www.yahoo.com&#47;&amp;"


it     "escapes valid relative path:"
input  "/path/mine/&"
output "&#47;path&#47;mine&#47;&amp;"


it     "raises Invalid_HREF if it contains unicode:"
input  "http://кц.рф"
raises Escape_Escape_Escape::Invalid_HREF, /bad URI/


it    'normalizes address:'
input "hTTp://wWw.test.com/"
output "http:&#47;&#47;wWw.test.com&#47;"


it     'fails w/ Invalid_HREF if invalid uri: < :'
input  "http://www.test.com/<something/"
raises Escape_Escape_Escape::Invalid_HREF, /http:\/\/www.test.com\/<something\//


it     'returns html escaped chars: \' :'
input  "http://www.test.com/?test='something/"
output "http:&#47;&#47;www.test.com&#47;?test=&#39;something&#47;"


it    'fails w/ Invalid_HREF if HTML entities in uri:'
input "http://6&#9;6.000146.0x7.147/"
raises Escape_Escape_Escape::Invalid_HREF, /bad URI/


it     'fails w/ Invalid_HREF if path contains html entities:'
input  "http://www.test.com/&nbsp;s/"
raises Escape_Escape_Escape::Invalid_HREF, /bad URI/


it     'fails w/ Invalid_HREF if query string contains HTML entities:'
input  "http://www.test.com/s/test?t&nbsp;test"
raises Escape_Escape_Escape::Invalid_HREF, /bad URI/



it     'does not re-escaped already escaped :href'
input  "http:&#47;&#47;www.example.com&#47;"
output "http:&#47;&#47;www.example.com&#47;"


it     'lower-cases scheme'
input  "hTTp://www.example.com/"
output "http:&#47;&#47;www.example.com&#47;"


it    'fails w/ Invalid_HREF if contains &sol;, regardless of case:'
input  "htTp:&soL;&sOl;file.com/img.png"
raises Escape_Escape_Escape::Invalid_HREF, /address is invalid/





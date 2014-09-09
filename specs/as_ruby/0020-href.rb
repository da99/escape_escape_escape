

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


it     'escapes all 70 different combos of "<"'
input  BRACKETS
output "&lt;"



it   'escapes all keys in nested objects'
input( {
  " a >" => {" a >"=> "<b>test</b>"}
})
output(  {
  " a &gt;" => {
    " a &gt;" => "&lt;b&gt;test&lt;&#47;b&gt;"
  }
})


it     'escapes all values in nested objects'
input(  {name: {name: "<b>test</b>"}} )
output( {name: {name: "&lt;b&gt;test&lt;&#47;b&gt;"}} )


it    'escapes all values in nested arrays'
input  [{name:{name: "<b>test</b>"}}]
output [{name: {name: "&lt;b&gt;test&lt;&#47;b&gt;"}}]


it     'does not re-escaped already escaped :href'
input  "http:&#47;&#47;www.example.com&#47;"
output "http:&#47;&#47;www.example.com&#47;"

it     'lower-cases scheme'
input  "hTTp://www.example.com/"
output "http:&#47;&#47;www.example.com&#47;"

it    'replaces &sOL;, regardless of case w: #047;'
input  "htTp:&soL;&sOl;file.com/img.png"
output "http:&#47;&#47;file.com&#47;img.png"





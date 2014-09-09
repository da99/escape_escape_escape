it     "does not re-escape already escaped html"
input  "<p>Hello &amp; GoodBye</p>"
output "&lt;p&gt;Hello &amp; GoodBye&lt;&#47;p&gt;"

it     "normalizes UNICODE: Ⅷ => VIII"
input  "<p> Ⅷ </p>"
output "&lt;p&gt; VIII &lt;&#47;p&gt;"

it     "normalizes UNICODE: \u2167 => VIII"
input  "<p> \u2167 </p>"
output "&lt;p&gt; VIII &lt;&#47;p&gt;"

it     "encodes apostrophe: ' -> &#39;"
input  "Chars: ' '"
output "Chars: &#39; &#39;"

it     'does not re-escape already escaped text mixed with HTML'
input  "&lt;p&gt;Hi&lt;&#47;p&gt;<p>Hi</p>"
output "&lt;p&gt;Hi&lt;&#47;p&gt;&lt;p&gt;Hi&lt;&#47;p&gt;"

it     'does not escape special chars: "Hello ©®∆"' 
input  "Hello & World ©®∆"
output "Hello &amp; World ©®∆"

it      'escapes all 70 different combos of "<"'
input   BRACKETS
output  "&lt; %3C"


it     "fails with RuntimeError if: true"
input  true
raises RuntimeError, /Not a string: true/


it     "fails with RuntimeError if: false"
input  false
raises RuntimeError, /Not a string: false/


it     "fails with RuntimeError if numeric"
input  1
raises RuntimeError, /Not a string: 1/



it     'has the same REGEX_UNSUITABLE_CHARS as Sanitize'
input  Escape_Escape_Escape::REGEX_UNSUITABLE_CHARS
output Sanitize::REGEX_UNSUITABLE_CHARS 

it     'removes Unicode characters that do not belong in html'
input  "b \u0340\u0341\u17a3\u17d3\u2028\u2029\u202a"
output "b "

it     "removes unprintable characters"
input  "end\u2028-\u2029"
output "end-"




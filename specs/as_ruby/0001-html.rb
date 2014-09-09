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
stack   [:split, :uniq, :join, [' '], "&lt; %3C &amp;lt &amp;LT &amp;LT; &amp;#60 &amp;#060 &amp;#0060 &amp;#00060 &amp;#000060 &amp;#0000060 &amp;#x3c &amp;#x03c &amp;#x003c &amp;#x0003c &amp;#x00003c &amp;#x000003c &amp;#x000003c; &amp;#X3c &amp;#X03c &amp;#X003c &amp;#X0003c &amp;#X00003c &amp;#X000003c &amp;#X000003c; &amp;#x3C &amp;#x03C &amp;#x003C &amp;#x0003C &amp;#x00003C &amp;#x000003C &amp;#x000003C; &amp;#X3C &amp;#X03C &amp;#X003C &amp;#X0003C &amp;#X00003C &amp;#X000003C &amp;#X000003C;"]


it     "fails with RuntimeError if: true"
input  true
raises RuntimeError, /Not a string: true/


it     "fails with RuntimeError if: false"
input  false
raises RuntimeError, /Not a string: false/


it     "fails with RuntimeError if numeric"
input  1
raises RuntimeError, /Not a string: 1/

it     'removes Unicode characters that do not belong in html'
input  "b \u0340\u0341\u17a3\u17d3\u2028\u2029\u202a"
output "b "

it     "removes unprintable characters"
input  "end\u2028-\u2029"
output "end-"




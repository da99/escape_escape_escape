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
output "Hello & World ©®∆"

it      'escapes all 70 different combos of "<"'
input   BRACKETS
output  "&lt; %3C"


it     "does not re-escape already escaped html"
input  "<p>Hello &amp; GoodBye</p>"
output "&lt;p&gt;Hello &amp; GoodBye&lt;&#47;p&gt;"

it     "normalizes UNICODE: Ⅷ => VIII"
input  "<p> Ⅷ </p>"
output "&lt;p&gt; VIII &lt;&#47;p&gt;"

it     "encodes apostrophe: ' -> &#39;"
input  "Chars: ' '"
output "Chars: &#39; &#39;"


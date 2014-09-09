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

it 'escapes all keys in nested objects' do
  html = "<b>test</b>"
  t    = {" a &gt;" => {" a &gt;" => E.escape(html) }}
  t.should == E.escape({" a >" => {" a >" => html}})
end

it 'escapes all values in nested objects' do
  html = "<b>test</b>"
  t    = {name: {name: E.escape(html)}}
  t.should == E.escape({name:{name: html}})
end

it 'escapes all values in nested arrays' do
  html = "<b>test</b>"
  [{name: {name: E.escape(html)}}].should == E.escape([{name:{name: html}}])
end

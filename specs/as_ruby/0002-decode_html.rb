it     "un-escapes special chars: \"Hello ©®∆\""
input  "Hello &amp; World &#169;&#174;&#8710;"
output "Hello & World ©®∆"

it    'un-escapes escaped text mixed with HTML'
input  "<p>Hi&amp;</p>"
output "<p>Hi&</p>"


it 'un-escapes all 70 different combos of "<"'
input BRACKETS
stack   [:split, :uniq, :join, [' '], '< %3C &lt &LT &LT; &#60 &#060 &#0060 &#00060 &#000060 &#0000060 &#x3c &#x03c &#x003c &#x0003c &#x00003c &#x000003c &#x000003c; &#X3c &#X03c &#X003c &#X0003c &#X00003c &#X000003c &#X000003c; &#x3C &#x03C &#x003C &#x0003C &#x00003C &#x000003C &#x000003C; &#X3C &#X03C &#X003C &#X0003C &#X00003C &#X000003C &#X000003C;']


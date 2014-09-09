it     "un-escapes special chars: \"Hello ©®∆\""
input  "Hello &amp; World &#169;&#174;&#8710;"
output "Hello & World ©®∆"

it    'un-escapes escaped text mixed with HTML'
input  "<p>Hi&amp;</p>"
output "<p>Hi&</p>"

it 'un-escapes special chars: "Hello ©®∆"'
input "Hello &amp; World &#169;&#174;&#8710;"
input "Hello & World ©®∆"

it 'un-escapes all 70 different combos of "<"'
input BRACKETS
output "< %3C"

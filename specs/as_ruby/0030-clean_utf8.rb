it     "normalizes string"
input  "Ⅷ"
output "VIII"

it     "normalizes string"
input  "\u2167"
output "VIII"


it "replaces nb spaces (160 codepoint) with regular ' ' spaces"
input [160, 160,64, 116, 119, 101, 108, 108, 121, 109, 101, 160, 102, 105, 108, 109].
    inject('', :<<)

output "@twellyme film"

it     "replaces tabs with spaces"
input  "a\t \ta"
output "a   a"

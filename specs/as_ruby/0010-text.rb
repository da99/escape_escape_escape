it     "replaces tabs with 2 spaces"
input  "<p>hello\tagain</p>"
output "<p>hello  again</p>"

it     "removes \\r"
input  "hi \r\r again"
output "hi  again"

it     "does not remove \\n"
input  "<p>hello\nagain</p>"
output "<p>hello\nagain</p>"

it     "does not remove multiple \\n"
input  "<p>hello\n \nagain</p>"
output "<p>hello\n \nagain</p>"




it     "raises Invalid_HREF if it has a javascript scheme:"
input  "javascript://something"
raises Escape_Escape_Escape::Invalid_HREF, /javascript/

it     "fails w/Invalid_Type if not a String"
input  :hello
raises Escape_Escape_Escape::Invalid_Type, /:hello/


it     "raises Invalid_Relative_HREF if it has a http scheme:"
input  "http://www.google.com"
raises Escape_Escape_Escape::Invalid_Relative_HREF, /google/


it     "returns string if it is relative:"
input  "/file.jpg"
output "&#47;file.jpg"


it     "returns string if it is relative:"
input  "file/file/file.jpg"
output "file&#47;file&#47;file.jpg"

it     "escapes slashes:"
input  "file/file.jpg"
output "file&#47;file.jpg"

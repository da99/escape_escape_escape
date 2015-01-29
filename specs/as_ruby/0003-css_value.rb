
it     'sanitizes :css :expression regardless of the case'
input  "eXprEssioN(alert('xss!'));"
raises Escape_Escape_Escape::Invalid, /contains invalid chars/

it    'sanitizes :css :expression when ( or ) is an html entity: &#40; &#41;'
input "eXprEssioN&#40;alert('xss!')&#41;"
raises Escape_Escape_Escape::Invalid, /contains invalid chars/


it     'sanitizes :css :expression when ( is html entity regardless of case: &rPaR;'
input  "eXprEssioN&rPaR;alert('xss!'))"
raises Escape_Escape_Escape::Invalid, /contains invalid chars/

it     'sanitizes css_href'
input  "smtp://file.com/img.png"
raises Escape_Escape_Escape::Invalid, /contains invalid chars/

it    'sanitizes css_href event if slash is html entity: &#47;'
input "smtp:&#47;&#47;file.com/img.png"
raises Escape_Escape_Escape::Invalid, /contains invalid chars/

it    'sanitizes css_href event if slash is html entity: &#x0002F;'
input "smtp:&#x0002F;&#x0002F;file.com/img.png"
raises Escape_Escape_Escape::Invalid, /contains invalid chars/


it     'sanitizes css_href event if slash is html entity: &sol;' 
input  "smtp:&sol;&sol;file.com/img.png"
raises Escape_Escape_Escape::Invalid, /contains invalid chars/

it     'sanitizes css_href with encoded slashes' 
input  "smtp:&#047;&#047;file.com&#047;img.png"
raises Escape_Escape_Escape::Invalid, /contains invalid chars/

it    'sanitizes javascript: protocol w/js code'
input 'jAvAscript://alert()'
raises Escape_Escape_Escape::Invalid, /contains invalid chars/

it    'sanitizes javascript: protocol with encoded colons:'
input "javascript&#058;//alert()"
raises Escape_Escape_Escape::Invalid, /contains invalid chars/

it     'sanitizes javascript: protocol with encoded slashes'
input  "javascript:&#047;&#047;alert()"
raises Escape_Escape_Escape::Invalid, /contains invalid chars/

it     'returns cleaned string'
input  '1px solid #000'
output '1px solid #000'





it     'allows commas and spaces'
input  :font, "Ubuntu, Segoe UI, Helvetica, sans-serif"
output "Ubuntu, Segoe UI, Helvetica, sans-serif"

it     'sanitizes :css :expression regardless of the case'
input  :url, "eXprEssioN(alert('xss!'));"
raises ArgumentError, /contains invalid chars/

it    'sanitizes :css :expression when ( or ) is an html entity: &#40; &#41;'
input  'border', "eXprEssioN&#40;alert('xss!')&#41;"
raises ArgumentError, /contains invalid chars/

it     'sanitizes :css :expression when ( is html entity regardless of case: &rPaR;'
input  'title', "eXprEssioN&rPaR;alert('xss!'))"
raises ArgumentError, /contains invalid chars/

it     'sanitizes css_href'
input  'css_href', "smtp://file.com/img.png"
raises ArgumentError, /contains invalid chars/

it    'sanitizes css_href event if slash is html entity: &#47;'
input  :img_url, "smtp:&#47;&#47;file.com/img.png"
raises ArgumentError, /contains invalid chars/

it    'sanitizes css_href event if slash is html entity: &#x0002F;'
input  'random', "smtp:&#x0002F;&#x0002F;file.com/img.png"
raises ArgumentError, /contains invalid chars/


it     'sanitizes css_href event if slash is html entity: &sol;' 
input  "smtp:&sol;&sol;file.com/img.png"
raises ArgumentError, /contains invalid chars/

it     'sanitizes css_href with encoded slashes' 
input  "smtp:&#047;&#047;file.com&#047;img.png"
raises ArgumentError, /contains invalid chars/

it    'sanitizes javascript: protocol w/js code'
input 'jAvAscript://alert()'
raises ArgumentError, /contains invalid chars/

it    'sanitizes javascript: protocol with encoded colons:'
input "javascript&#058;//alert()"
raises ArgumentError, /contains invalid chars/

it     'sanitizes javascript: protocol with encoded slashes'
input  "javascript:&#047;&#047;alert()"
raises ArgumentError, /contains invalid chars/

it     'returns cleaned string'
input  '1px solid #000'
output '1px solid #000'

it     'allows multiple border_width sizes: 0 0 0.5em 3px'
input  'border_width', '0 0 0.5em 3px'
output '0 0 0.5em 3px'

it     'allows % sign in border_width sizes: 0 0 0.5% 3%'
input  'border_width', '0 0 0.5% 3%'
output '0 0 0.5% 3%'



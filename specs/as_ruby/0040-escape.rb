


it 'turns numerics into strings: 1.004'
input 1.004
output '1.004'


it 'raises Invalid if Object'
input Object.new
raises Escape_Escape_Escape::Invalid, /Not a String, Number, Array, or Hash/i


it 'escapes all String keys in nested objects'
input({"   a >" => {" a >  " => "<b>test</b>"}})
output({
  "a &gt;" => {
    "a &gt;" => "&lt;b&gt;test&lt;&#47;b&gt;"
  }
})


it 'escapes all Symbol keys in nested objects'
input({:"   a >   " => {:" a >" => "<b>test</b>"}})
output({
  :"a &gt;" => {
    :"a &gt;" => "&lt;b&gt;test&lt;&#47;b&gt;"
  }
})



it 'escapes all values in nested objects'
input(  {name: {name: "<b>test</b>"}} )
output( {name: {name: "&lt;b&gt;test&lt;&#47;b&gt;"}} )



it 'escapes all values in nested arrays'
input  [{name:{name: '<b>test</b>'}}]
output [{name: {name: "&lt;b&gt;test&lt;&#47;b&gt;"}}]

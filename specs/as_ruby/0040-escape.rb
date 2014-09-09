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

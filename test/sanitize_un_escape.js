
var _      = require('underscore')
, _s       = require('underscore.string')
, unhtml   = require('unhtml')
, special  = require('special-html')
, assert   = require('assert')
, Sanitize = require('../lib/e_e_e').Sanitize
, E        = Sanitize.html
, U        = Sanitize.un_escape
;
var BRACKET = " < %3C &lt &lt; &LT &LT; &#60 &#060 &#0060  \
&#00060 &#000060 &#0000060 &#60; &#060; &#0060; &#00060;  \
&#000060; &#0000060; &#x3c &#x03c &#x003c &#x0003c &#x00003c  \
&#x000003c &#x3c; &#x03c; &#x003c; &#x0003c; &#x00003c;  \
&#x000003c; &#X3c &#X03c &#X003c &#X0003c &#X00003c &#X000003c  \
&#X3c; &#X03c; &#X003c; &#X0003c; &#X00003c; &#X000003c;  \
&#x3C &#x03C &#x003C &#x0003C &#x00003C &#x000003C &#x3C; &#x03C;  \
&#x003C; &#x0003C; &#x00003C; &#x000003C; &#X3C &#X03C  \
&#X003C &#X0003C &#X00003C &#X000003C &#X3C; &#X03C; &#X003C; &#X0003C;  \
&#X00003C; &#X000003C; \x3c \x3C \u003c \u003C ";


describe( 'Sanitize', function () {

  it( 'un-escapes escaped text mixed with HTML', function () {
    var s = "<p>Hi&amp;</p>";
    assert.equal(U(s), "<p>Hi&</p>");
  });

  it( 'un-escapes special chars: "Hello ©®∆"', function () {
    var s = "Hello &amp; World &#169;&#174;&#8710;";
    var t = "Hello & World ©®∆";
    assert.equal(U(s), t);
  });

  it( 'un-escapes all 70 different combos of "<"', function () {
    assert.equal(_.uniq(U(BRACKET.trim()).split(/\s+/)).join(' '), "< %3C");
  });

}); // === end desc


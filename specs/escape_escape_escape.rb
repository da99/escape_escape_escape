
require "multi_json"
require "escape_escape_escape"

BRACKET = " < %3C &lt &lt; &LT &LT; &#60 &#060 &#0060
&#00060 &#000060 &#0000060 &#60; &#060; &#0060; &#00060;
&#000060; &#0000060; &#x3c &#x03c &#x003c &#x0003c &#x00003c
&#x000003c &#x3c; &#x03c; &#x003c; &#x0003c; &#x00003c;
&#x000003c; &#X3c &#X03c &#X003c &#X0003c &#X00003c &#X000003c
&#X3c; &#X03c; &#X003c; &#X0003c; &#X00003c; &#X000003c;
&#x3C &#x03C &#x003C &#x0003C &#x00003C &#x000003C &#x3C; &#x03C;
&#x003C; &#x0003C; &#x00003C; &#x000003C; &#X3C &#X03C
&#X003C &#X0003C &#X00003C &#X000003C &#X3C; &#X03C; &#X003C; &#X0003C;
&#X00003C; &#X000003C; \x3c \x3C \u003c \u003C ".strip

Dir.glob("specs/as_json/*.json").sort.each { |f|
  contents = MultiJson.load(File.read f)
  method_name = File.basename(f).gsub(/\A\d+-|\.json\Z/, '')
  describe ":#{method_name}" do
    contents.each { |t|
      it t["it"] do
        i      = t["input"]
        o      = t["output"]
        actual = Escape_Escape_Escape.send(method_name, i)

        case o
        when String
          actual.should == o
        when Array
          target = o.pop
          begin
            if o[1].is_a?(Array)
              meth = o.shift
              args = o.shift
              actual = actual.send(meth, *args)
            else
              fail "Unknown method: #{o[0].inspect}"
            end
          end while !o.empty?

          actual.should == target
        end # === case
      end # === it
    }
  end
}



describe ":clean_utf8" do

  it "replaces nb spaces (160 codepoint) with regular ' ' spaces" do
    s = [160, 160,64, 116, 119, 101, 108, 108, 121, 109, 101, 160, 102, 105, 108, 109].
      inject('', :<<)

    assert :==, "@twellyme film", Okdoki::Escape_All.clean_utf8(s).strip
  end

  it "replaces tabs with spaces" do
    s = "a\t \ta"
    assert :==, "a   a", Okdoki::Escape_All.clean_utf8(s)
  end

end # === describe :clean_utf8 ===



describe ':un_e' do

  it 'un-escapes escaped text mixed with HTML' do
    s = "<p>Hi&amp;</p>";
    assert :==, "<p>Hi&</p>", Okdoki::Escape_All.un_e(s);
  end

  it 'un-escapes special chars: "Hello ©®∆"' do
    s = "Hello &amp; World &#169;&#174;&#8710;"
    t = "Hello & World ©®∆"
    assert :==, t, Okdoki::Escape_All.un_e(s)
  end

  it 'un-escapes all 70 different combos of "<"' do
    assert :==, "< %3C", Okdoki::Escape_All.un_e(BRACKET).split.uniq.join(' ')
  end

end # === describe :un_e


describe ':escape' do

  it 'does not re-escape already escaped text mixed with HTML' do
    h = "<p>Hi</p>";
    e = Okdoki::Escape_All.escape(h);
    o = e + h;
    assert :==, Okdoki::Escape_All.escape(o), Okdoki::Escape_All.escape(h + h)
  end

  it 'escapes special chars: "Hello ©®∆"' do
    s = "Hello & World ©®∆"
    t = "Hello &amp; World &#169;&#174;&#8710;"
    t = "Hello &amp; World &copy;&reg;&#x2206;"
    assert :==, t, Okdoki::Escape_All.escape(s)
  end

  it 'escapes all 70 different combos of "<"' do
    assert :==, "&lt; %3C", Okdoki::Escape_All.escape(BRACKET).split.uniq.join(' ')
  end

  it 'escapes all keys in nested objects' do
    html = "<b>test</b>"
    t    = {" a &gt;" => {" a &gt;" => Okdoki::Escape_All.escape(html) }}
    assert :==, t, Okdoki::Escape_All.escape({" a >" => {" a >" => html}})
  end

  it 'escapes all values in nested objects' do
    html = "<b>test</b>"
    t    = {name: {name: Okdoki::Escape_All.escape(html)}}
    assert :==, t, Okdoki::Escape_All.escape({name:{name: html}})
  end

  it 'escapes all values in nested arrays' do
    html = "<b>test</b>"
    assert :==, [{name: {name: Okdoki::Escape_All.escape(html)}}], Okdoki::Escape_All.escape([{name:{name: html}}])
  end

  'uri url href'.split.each { |k| # ==============================================

    it "escapes values of keys :#{k} that are valid /path" do
      a = {:key=>{:"#{k}" => "/path/mine/&"}}
      t = {:key=>{:"#{k}" => "/path/mine/&amp;"}}
      assert :==, t, Okdoki::Escape_All.escape(a)
    end

    it "sets nil any keys ending with :#{k} and have invalid uri" do
      a = {:key=>{:"#{k}" => "javascript:alert(s)"}}
      t = {:key=>{:"#{k}" => nil                  }}
      assert :==, t, Okdoki::Escape_All.escape(a)
    end

    it "sets nil any keys ending with _#{k} and have invalid uri" do
      a = {:key=>{:"my_#{k}" => "javascript:alert(s)"}}
      t = {:key=>{:"my_#{k}" => nil                  }}
      assert :==, t, Okdoki::Escape_All.escape(a)
    end

    it "escapes values of keys with _#{k} that are valid https uri" do
      a = {:key=>{:"my_#{k}" => "https://www.yahoo.com/&"}}
      t = {:key=>{:"my_#{k}" => "https://www.yahoo.com/&amp;"}}
      assert :==, t, Okdoki::Escape_All.escape(a)
    end

    it "escapes values of keys with _#{k} that are valid uri" do
      a = {:key=>{:"my_#{k}" => "http://www.yahoo.com/&"}}
      t = {:key=>{:"my_#{k}" => "http://www.yahoo.com/&amp;"}}
      assert :==, t, Okdoki::Escape_All.escape(a)
    end

    it "escapes values of keys ending with _#{k} that are valid /path" do
      a = {:key=>{:"my_#{k}" => "/path/mine/&"}}
      t = {:key=>{:"my_#{k}" => "/path/mine/&amp;"}}
      assert :==, t, Okdoki::Escape_All.escape(a)
    end

    it "allows unicode uris" do
      a = {:key=>{:"my_#{k}" => "http://кц.рф"}}
      t = {:key=>{:"my_#{k}" => "http://&#x43a;&#x446;.&#x440;&#x444;"}}
      assert :==, t, Okdoki::Escape_All.escape(a)
    end
  }

  # === password field
  it "does not escape :pass_word key" do
    a = {:pass_word=>"&&&"}
    assert :==, a, Okdoki::Escape_All.escape(a)
  end

  it "does not escape :confirm_pass_word key" do
    a = {:confirm_pass_word=>"&&&"}
    assert :==, a, Okdoki::Escape_All.escape(a)
  end

  [true, false].each do |v|
    it "does not escape #{v.inspect}" do
      a = {:something=>v}
      assert :==, a, Okdoki::Escape_All.escape(a)
    end
  end

  it "does not escape numbers" do
    a = {:something=>1}
    assert :==, a, Okdoki::Escape_All.escape(a)
  end

end # === end desc



describe( 'uri' ) {

  it( 'normalizes address' ) {
    var s = "hTTp://wWw.test.com/";
    assert.equal(E.uri(s), s.toLowerCase());
  }

  it( 'returns an Error if path contains: <' ) {
    var s = "http://www.test.com/<something/";
    assert.equal(E.uri(s).constructor, Error);
  }

  it( 'returns an Error if path contains HTML entities' ) {
    var s = "http://6&#9;6.000146.0x7.147/";
    assert.equal(E.uri(s).constructor, Error);
  }

  it( 'returns an Error if path contains HTML entities' ) {
    var s = "http://www.test.com/&nbsp;s/";
    assert.equal(E.uri(s).constructor, Error);
  }

  it( 'returns an Error if query string contains HTML entities' ) {
    var s = "http://www.test.com/s/test?t&nbsp;test";
    assert.equal(E.uri(s).constructor, Error);
  }

} # === end desc



describe( 'Sanitize') {

  it( 'un-escapes escaped text mixed with HTML') {
    s = "<p>Hi&amp;</p>"
    assert.equal(U(s), "<p>Hi&</p>")
  }

  it( 'does not re-escape already escaped text mixed with HTML') {
    h = "<p>Hi</p>"
    e = _s.escapeHTML(h)
    o = e + h
    assert.equal(E(o), _s.escapeHTML(h + h))
  }

  it( 'escapes special chars: "Hello ©®∆"') {
    s = "Hello & World ©®∆"
    t = "Hello &amp; World &#169;&#174;&#8710;"
    assert.equal(E(s), t)
  }

  it( 'un-escapes special chars: "Hello ©®∆"') {
    s = "Hello &amp; World &#169;&#174;&#8710;"
    t = "Hello & World ©®∆"
    assert.equal(U(s), t)
  }

  it( 'escapes all 70 different combos of "<"') {
    assert.equal(_.uniq(E(BRACKET.trim()).split(/\s+/)).join(' '), "&lt; %3C")
  }

  it( 'un-escapes all 70 different combos of "<"') {
    assert.equal(_.uniq(U(BRACKET.trim()).split(/\s+/)).join(' '), "< %3C")
  }

  it( 'escapes all keys in nested objects') {
    HTML = "<b>test</b>"
    input = {
      " a >" => {" a >"=> HTML}
    }
    output = {
      " a &gt;" => {
        " a &gt;" => string.escapeHTML(HTML)
      }
    }
    E(input).should == output
  }

  it( 'escapes all values in nested objects') {
    HTML = "<b>test</b>"
    E({name:{name: HTML}}).should == {name: {name: _s.escapeHTML(HTML)}}
  }

  it( 'escapes all values in nested arrays') {
    HTML = "<b>test</b>"
    assert.deepEqual(E([{name:{name: HTML}}]), [{name: {name: _s.escapeHTML(HTML)}}])
  }

} # // === end desc







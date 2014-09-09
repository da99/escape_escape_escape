
require "multi_json"
require "escape_escape_escape"

BRACKETS = <<-EOF.split.join(' ')
< %3C &lt &lt; &LT &LT; &#60 &#060 &#0060
&#00060 &#000060 &#0000060 &#60; &#060; &#0060; &#00060;
&#000060; &#0000060; &#x3c &#x03c &#x003c &#x0003c &#x00003c
&#x000003c &#x3c; &#x03c; &#x003c; &#x0003c; &#x00003c;
&#x000003c; &#X3c &#X03c &#X003c &#X0003c &#X00003c &#X000003c
&#X3c; &#X03c; &#X003c; &#X0003c; &#X00003c; &#X000003c;
&#x3C &#x03C &#x003C &#x0003C &#x00003C &#x000003C &#x3C; &#x03C;
&#x003C; &#x0003C; &#x00003C; &#x000003C; &#X3C &#X03C
&#X003C &#X0003C &#X00003C &#X000003C &#X3C; &#X03C; &#X003C; &#X0003C;
&#X00003C; &#X000003C; \x3c \x3C \u003c \u003C
EOF


class It_Dsl
  class << self

    def tests
      @tests ||= []
    end

    def args
      @args ||= []
    end

    def describe str
      tests << {:describe => str, :tests=>[]}
    end

    def it str
      @args << str
    end

    def input o
      @args << o
    end

    def output o
      if args.size != 2
        fail "Missing values: #{args.inspect}, #{o.inspect}"
      end

      i = args.pop
      name = args.pop
      test = {it: name, input: i, output: o}

      test[:it] = if test[:it].strip[/:\z/]
                    "#{test[:it]} #{test[:input]}"
                  else
                    test[:it]
                  end

      tests.last[:tests] << test
    end

  end # === class << self
end # == class It_Dsl

Dir.glob("specs/as_ruby/*.rb").sort.each { |f|

  contents    = File.read f
  method_name = File.basename(f).gsub(/\A\d+-|\.rb\z/, '')

  It_Dsl.describe method_name.to_sym
  It_Dsl.instance_eval contents, f

} # === Dir.glob


It_Dsl.tests.each { |o|

  describe o[:describe] do
    o[:tests].each { |t|
      it t[:it] do
        input  = t[:input]
        output = t[:output]
        actual = Escape_Escape_Escape.send(o[:describe], input)

        case output
        when Array
          target = output.pop
          begin
            if output[1].is_a?(Array)
              meth = output.shift
              args = output.shift
              actual = actual.send(o[:describe], *args)
            else
              fail "Unknown method: #{output[0].inspect}"
            end
          end while !output.empty?

          actual.should == target

        else
          actual.should == output

        end # === case
      end # === it
    }
  end
} # === It_Dsl


describe( 'uri' ) {

  it( 'normalizes address' ) {
    s = "hTTp://wWw.test.com/"
    E.uri(s).should == s.upcase
  }

  it( 'returns an Error if path contains: <' ) {
    s = "http://www.test.com/<something/"
    E.uri(s).should == s.upcase
  }

  it( 'returns an Error if path contains HTML entities' ) {
    s = "http://6&#9;6.000146.0x7.147/"
    E.uri(s).should == s.upcase
  }

  it( 'returns an Error if path contains HTML entities' ) {
    s = "http://www.test.com/&nbsp;s/"
    E.uri(s).should == s.upcase
  }

  it( 'returns an Error if query string contains HTML entities' ) {
    s = "http://www.test.com/s/test?t&nbsp;test"
    E.uri(s).should == s.upcase
  }

} # === end desc

describe( 'Sanitize') {

  it( 'escapes all 70 different combos of "<"') {
    E(BRACKET.strip).split.uniq.join(' ').should == "&lt;"
  }

  it( 'un-escapes all 70 different combos of "<"') {
    U(BRACKET.strip).split.join(' ').should == "<"
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
    E([{name:{name: HTML}}]).should == [{name: {name: _s.escapeHTML(HTML)}}]
  }

} # // === end desc



describe :other do

  describe :html do

    it 'has the same REGEX_UNSUITABLE_CHARS as Sanitize' do
      Escape_Escape_Escape::REGEX_UNSUITABLE_CHARS.
        should == Sanitize::REGEX_UNSUITABLE_CHARS 
    end

    it 'removes Unicode characters that do not belong in html' do
      input = "\u0340\u0341\u17a3\u17d3\u2028\u2029\u202a"
      E(input).should == ''
    end

    it "removes unprintable characters" do
      input = "end\u2028-\u2029"
      E(input).
        should == "end-"
    end

  end # === describe

  describe :href do

    it 'does not re-escaped already escaped :href' do
      input = EscapeUtils.escape_html("http://www.example.com/")
      E(input).should == input
    end

    it 'lower-cases scheme' do
      input = "hTTp://www.example.com/"
      E(input).should == EscapeUtils.escape_html(input).downcase
    end

    it 'replaces &sOL;, regardless of case w: #047;' do
      input = "htTp:&sol;&sol;file.com/img.png"
      E(input).should == EscapeUtils.escape_html("http://file.com/img.png")
    end

  end # === :href

end # === describe :other




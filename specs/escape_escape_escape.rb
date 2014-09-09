
require 'Bacon_Colored'
require 'escape_escape_escape'
require 'pry'

require "multi_json"
require "escape_escape_escape"
require 'sanitize'

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
      args << str
    end

    def input o
      args << o
    end

    def << t
      if !args.empty?
        fail "Unknown values pending for: #{tests.last[:describe]}: #{args.inspect}, #{o.inspect}"
      end

      t[:it] = if t[:it].strip[/:\z/]
                    "#{t[:it]} #{t[:input]}"
                  else
                    t[:it]
                  end

      tests.last[:tests] << t
    end

    def raises o, m
      self << {it: args.shift, input: args.pop, raises: [o, m]}
    end

    def output o
      self << {it: args.shift, input: args.pop, output: o}
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

        case

        when t.has_key?(:output)
          Escape_Escape_Escape.send(o[:describe], t[:input])
          .should == t[:output]

        when !t.has_key?(:output) && t[:raises]
          should.raise(t[:raises].first) {
            Escape_Escape_Escape.send(o[:describe], t[:input])
          }.message.should.match(t[:raises].last)

        when t[:output].is_a?(Array)

          target = t[:output].pop

          begin
            if t[:output][1].is_a?(Array)
              meth = t[:output].shift
              args = t[:output].shift
              actual = actual.send(o[:describe], *args)
            else
              fail "Unknown method: #{t[:output][0].inspect}"
            end
          end while !t[:output].empty?

          Escape_Escape_Escape.send(o[:describe], t[:input]).
            should == target

        else
          fail "Unknown args for test: #{t.inspect}"

        end # === case
      end # === it
    }
  end
} # === It_Dsl




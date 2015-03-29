
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

    def input *o
      args << o
    end

    def << t
      if !args.empty?
        fail "Unknown values pending for: #{tests.last[:describe]}: #{args.inspect}"
      end

      t[:it] = if t[:it].strip[/:\z/]
                    "#{t[:it]} #{t[:input].inspect}"
                  else
                    t[:it]
                  end

      tests.last[:tests] << t
    end

    def stack arr
      self << {it: args.shift, input: args.pop, stack: arr}
    end

    def raises o, m
      self << {it: args.shift, input: args.pop, raises: [o, m]}
    end

    def output o
      self << {it: args.shift, input: args.pop, output: o}
    end

  end # === class << self
end # == class It_Dsl

# =================================================
glob = ENV['RUBY_TEST_FILE'].to_s.strip.empty? ?
  "specs/as_ruby/*.rb" :
  ENV['RUBY_TEST_FILE']
# =================================================

Dir.glob(glob).sort.each { |f|

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

        when o[:describe] == :==
          t[:input].should == [t[:output]]

        when t.has_key?(:output)
          Escape_Escape_Escape.send(o[:describe], *t[:input])
          .should == t[:output]

        when !t.has_key?(:output) && t[:raises]
          should.raise(t[:raises].first) {
            Escape_Escape_Escape.send(o[:describe], *t[:input])
          }.message.should.match(t[:raises].last)

        when t.has_key?(:stack) && t[:stack].is_a?(Array)

          stack = t[:stack]
          actual = Escape_Escape_Escape.send(o[:describe], *t[:input])
          target = stack.pop

          begin
            case
            when stack[1].is_a?(Array)
              meth = stack.shift
              args = stack.shift
              actual = actual.send(meth, *args)

            when stack.first.is_a?(Symbol)
              actual = actual.send(stack.shift)

            else
              fail "Unknown method: #{stack[0].inspect}"

            end
          end while !stack.empty?

          actual.should == target

        else
          fail "Unknown args for test: #{t.inspect}"

        end # === case
      end # === it
    }
  end
} # === It_Dsl





require "multi_json"
require "escape_escape_escape"

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

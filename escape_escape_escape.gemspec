# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "escape_escape_escape"
  spec.version       = `cat VERSION`
  spec.authors       = ["da99"]
  spec.email         = ["i-hate-spam-1234567@mailinator.com"]
  spec.summary       = %q{My way of escaping/encoding HTML.}
  spec.description   = %q{
    My way of escaping/encoding HTML with the proper entities.
  }
  spec.homepage      = "https://github.com/da99/escape_escape_escape"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |file|
    file.index('bin/') == 0 && file != "bin/#{File.basename Dir.pwd}"
  }
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "addressable"  , "> 2.3.5"
  spec.add_runtime_dependency "escape_utils" , "> 1.0.0"
  spec.add_runtime_dependency "unf"          , "> 0.1.3"
  spec.add_runtime_dependency "htmlentities" , ">= 4.3.2"
  spec.add_runtime_dependency "multi_json"   , "> 1.10.0"
  spec.add_runtime_dependency "oj"           , "> 2.10.1"

  spec.add_development_dependency "pry"           , ">= 0.9"
  spec.add_development_dependency "rake"          , ">= 10.3"
  spec.add_development_dependency "bundler"       , ">= 1.5"
  spec.add_development_dependency "bacon"         , ">= 1.0"
  spec.add_development_dependency "Bacon_Colored" , ">= 0.1"
  spec.add_development_dependency "sanitize"    , ">= 3.0.1"
end

# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "literate_ruby/version"

Gem::Specification.new do |s|
  s.name        = "literate_ruby"
  s.version     = LiterateRuby::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andrew O'Brien"]
  s.email       = ["obrien.andrew@gmail.com"]
  s.homepage    = "http://github.com/AndrewO/literate_ruby"
  s.summary     = %q{Don't comment your code. Code your comments.}
  s.description = %q{Literate Ruby is a small preprocessor that allows embedding code within text files and then loading them as programs.}

  s.rubyforge_project = "literate_ruby"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

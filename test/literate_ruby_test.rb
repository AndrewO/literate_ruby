require 'rubygems'
require 'bundler'
Bundler.require(:default, :test)

require 'minitest/spec'
require 'minitest/autorun'

require 'wrong/adapters/minitest'

$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require "literate_ruby"

FIXTURE_DIR = File.join(File.dirname(__FILE__), "fixtures")

describe LiterateRuby do
  it "parses literate ruby files returning annotated lines" do
    lines = LiterateRuby.parse(File.new(File.join(FIXTURE_DIR, "fixture.lrb")))

    assert_fixture_parses(lines)
  end
  
  it "loads a literate Ruby file returning annotated lines" do
    lines = LiterateRuby.load(File.join(FIXTURE_DIR, "fixture.lrb"))

    assert_fixture_parses(lines)

    assert { FOO == 123 }
    assert { foo() == 2 }
    assert { BAR == 456 }
  end

  # Leaving this out for now. It works, but until I see someone trying to write libs in lrb, it might not be worth it to
  # rewrite Ruby's load path searching, especially since that's changing.
  # it "requires a literate Ruby file" do
  #   LiterateRuby.require(File.join(FIXTURE_DIR, "require_fixture"))
  # 
  #   assert { bar() == 80 }
  #   assert { BAZ == 678 }
  #   assert { $".grep(/require_fixture.lrb$/) }
  #   
  #   deny { LiterateRuby.require(File.join(FIXTURE_DIR, "require_fixture")) }
  # end

  def assert_fixture_parses(lines)
    expected = [
      [:data, 
        [
          [1, "FOO is declared to be 123\n"],
          [2, "Let's test multines\n"],
          [3, "\n"],
          [4, "And paragraph breaks\n"]
        ]
      ],
     [:code, 
       [
         [5, " FOO = 123\n"], 
         [6, " def foo\n"], 
         [7, "  1 + 1\n"], 
         [8, " end\n"]
        ]
      ],
      [:data, 
        [
          [9, "\n"], 
          [10, "BAR is 456\n"], 
          [11, "\n"]
        ]
      ],
      [:code, 
        [
          [13, "BAR = \n"], 
          [14, "  456\n"]
        ]
      ]
    ]
    
    assert { lines == expected}
  end
end
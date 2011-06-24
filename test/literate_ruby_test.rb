require 'rubygems'
require 'bundler'
Bundler.require(:default, :test)

require 'minitest/spec'
require 'minitest/autorun'

require 'prettyprint'

require 'wrong/adapters/minitest'

$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require "literate_ruby"

FIXTURE_DIR = File.join(File.dirname(__FILE__), "fixtures")

describe LiterateRuby do
  it "parses literal ruby files and returns code and data sections" do
    lines = LiterateRuby.parse(File.new(File.join(FIXTURE_DIR, "fixture.lrb")))

    expected = [
      [:data, %{FOO is declared to be 123\n}],
      [:data, %{Let's test multines\n}],
      [:data, "\n"],
      [:data, %{And paragraph breaks\n}],
      [:code, %{ FOO == 123\n}],
      [:code, %{ def foo\n}],
      [:code, %{  1 + 1\n}],
      [:code, %{ end\n}],
      [:data, "\n"],
      [:data, "BAR is 456\n"],
      [:data, "\n"],
      [:code, "BAR = \n"],
      [:code, "  456\n"]
    ]
    
    assert { lines == expected}
  end
end
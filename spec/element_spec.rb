require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'anvl/erc'

describe "ERC element" do
  it "should handle basic mapping" do
    h = ANVL::Erc::Element.new :label => 'abc', :value => '123'
    h.to_s.should == "123"
    h.to_anvl.should == "abc: 123"
  end

  it "should support an initial comment to record natural word order" do
    h = ANVL::Erc::Element.new :label => 'abc', :value => ',  van Gogh, Vincent'
    h.to_s.should == "Vincent van Gogh"
    h.to_anvl.should == "abc:,  van Gogh, Vincent"

    h = ANVL::Erc::Element.new :label => 'abc', :value => ',  Howell, III, PhD, 1922-1987, Thurston'
    h.to_s.should == "Thurston Howell, III, PhD, 1922-1987"
    h.to_anvl.should == "abc:,  Howell, III, PhD, 1922-1987, Thurston"

    h = ANVL::Erc::Element.new :label => 'abc', :value => ',  McCartney, Paul, Sir,'
    h.to_s.should == "Sir Paul McCartney"
    h.to_anvl.should == "abc:,  McCartney, Paul, Sir,"
  end
end

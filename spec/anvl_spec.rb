require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ANVL" do
  describe "parsing tests" do
    it "should parse empty files" do
      anvl = ANVL.parse('')
      anvl.entries.should have(0).items
    end

    it "should ignore comment lines" do
      anvl = ANVL.parse("#")
      anvl.entries.should have(0).items
    end

    it "should handle multiple values" do
      anvl = ANVL.parse "entry:
a: 1
a: 2"

      anvl[:a].should == ["1","2"]
    end

    it "should suport string or key access" do
      str = 'erc:
who:    Lederberg, Joshua
what:   Studies of Human Families for Genetic Linkage
when:   1974
where:  http://profiles.nlm.nih.gov/BB/AA/TT/tt.pdf
note:   This is an arbitrary note inside a
        small descriptive record.'
      anvl = ANVL::Document.parse str
      anvl['who'].should == anvl[:who]


    end


    it "should parse a complete document" do
      anvl = ANVL.parse <<-eos
entry: 
# first draft 
who: Gilbert, W.S. | Sullivan, Arthur 
what: The Yeomen of
      the Guard 
when/created: 1888
eos
      anvl[:entry].should == ""
      anvl[:who].should == "Gilbert, W.S. | Sullivan, Arthur"
      anvl[:what].should == "The Yeomen of the Guard"
      anvl[:"when/created"].should == "1888"

    end
  end

  describe "serializing test" do
    it "should output an empty document" do
      str = ANVL.to_anvl({})
      str.should == ""
    end

    it "should handle new lines by indenting appropriately" do
      str = ANVL.to_anvl({:with_newline => "abc\n123"})
      str.should == "with_newline: abc\n    123"
    end

    it "should support label aliases" do
      str = ANVL.to_anvl(:a => {:display_label => 'A', :value => '123'})
      str.should match(/A: 123/)
    end

    it "should serialize a complete document" do
      str = ANVL.to_anvl({:entry => [""], :who => ['Gilbert, W.S. | Sullivan, Arthur'], :what => ["The Yeomen of the Guard"], :"when/created" => [1888]})

      arr = str.split("\n")
      
      arr.should include("who: Gilbert, W.S. | Sullivan, Arthur", "what: The Yeomen of the Guard", "when/created: 1888")

    end

    it "should support iteratively building a document" do
      anvl = ANVL::Document.new
      anvl[:a].should == []

      anvl[:a] = 'a'
      anvl.to_h.should == {:a => 'a'}

      anvl[:a] = ['a', 'b']
      anvl.to_h.should == {:a => ['a', 'b']}

      anvl.store :a, 'c', true
      anvl.to_h.should == {:a => ['a', 'b', 'c']}

      anvl << { :a => 'd' }
      anvl.to_h.should == {:a => ['a', 'b', 'c', 'd']}

      anvl[:b]
      anvl.to_h[:b].should be_nil

      anvl << { :c => 1 }
      anvl[:c].should == "1"

      anvl << { :c => 2 }
      anvl[:c].should == ["1", "2"]

      arr = anvl.to_s.split("\n")
      arr.should include("a: a", "a: b", "a: c", "a: d", "c: 1", "c: 2")
    end
  end
end


require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'anvl/erc'

describe "test ERC record handling" do
  it "should handle empty files" do
    ANVL::Erc.parse('').entries.should have(0).items
  end

  it "should handle basic ERC record" do
    str = 'erc:
who:    Gibbon, Edward
what:   The Decline and Fall of the Roman Empire
when:   1781
where:  http://www.ccel.org/g/gibbon/decline/'

    erc = ANVL::Erc.parse str

    erc[:erc].should == ""
    erc[:who].should == "Gibbon, Edward"
    erc[:what].should == "The Decline and Fall of the Roman Empire"
    erc[:when].should == "1781"
    erc[:where].should == "http://www.ccel.org/g/gibbon/decline/"
  end

  it "should support label structure agnostic key access" do
    str = 'erc:'
    erc = ANVL::Erc.parse str

    erc['marc_856'] = 'abc'
    erc['MARC 856'].should == 'abc'

    erc['MARC 856'] = '123'
    erc['marc_856'].should == '123'

  end

  it "should support internationalized key access" do
    str = 'erc:
who:    Lederberg, Joshua
h2:   Studies of Human Families for Genetic Linkage'
    erc = ANVL::Erc.parse str

    erc[:who].should == erc['who']
    erc[:who].should == erc[:h1]
    erc[:who].should == erc['wer(h1)']

    erc[:h2].should == erc[:what]
    erc[:h2].should == erc['was(h2)']

  end

  it "should handle multiple values delimited by a semi-colon" do
    str = 'erc:
who:  Smith, J; Wong, D; Khan, H'
    erc = ANVL::Erc.parse str

    erc[:who].should include("Smith, J", "Wong, D", "Khan, H")
  end

  it "should handle value normaliation" do
    str = 'erc:
who:,  van Gogh, Vincent
who:,  Howell, III, PhD, 1922-1987, Thurston
who:,  Acme Rocket Factory, Inc., The
who:,  Mao Tse Tung
who:,  McCartney, Pat, Ms,
who:,  McCartney, Paul, Sir,
who:,  McCartney, Petra, Dr,
what:, Health and Human Services, United States Government
    Department of, The,'

    erc = ANVL::Erc.parse str

    erc[:who].should include("Vincent van Gogh", "Thurston Howell, III, PhD, 1922-1987", "The Acme Rocket Factory, Inc.", "Mao Tse Tung", "Ms Pat McCartney", "Sir Paul McCartney", "Dr Petra McCartney")
    erc[:what].should == "The United States Government Department of Health and Human Services"

  end
  
  it "should unescape value encoding" do
    str = 'erc:
who: %sp%ex%dq'
    h = ANVL::Erc.parse str
    h[:who].should == ' !"'
  end

  it "should test for completeness" do
    str = 'erc:
what:    The Digital Dilemma
where:  http://books.nap.edu/html/digital%5Fdilemma
    '

    erc = ANVL::Erc.parse str
    erc.should_not be_complete

    erc[:who] = '---'
    erc[:when] = '---'
    erc.should be_complete

  end

  describe "abbreviated view" do
    it "should parse to full document" do
      str = 'erc: Gibbon, Edward | The Decline and Fall of the Roman Empire
         | 1781 | http://www.ccel.org/g/gibbon/decline/'
      erc = ANVL::Erc.parse str
       
      erc[:erc].should be_empty
      erc[:who].should == "Gibbon, Edward"
      erc[:what].should == "The Decline and Fall of the Roman Empire"
      erc[:when].should == "1781"
      erc[:where].should == "http://www.ccel.org/g/gibbon/decline/"

    end

  end

  describe "meta erc document" do
    it "may be considered complete" do
      str = 'meta-erc:  NLM | pm9546494 | 19980418
               | http://ark.nlm.nih.gov/12025/pm9546494??'
      erc = ANVL::Erc.parse str
      erc.should be_complete

    end
  end
  
  describe "about erc document" do
    it "should handle missing values" do
      str = 'about-erc:   | Bispectrum ; Nonlinearity ; Epilepsy
                   ; Cooperativity ; Subdural ; Hippocampus'
      erc = ANVL::Erc.parse str
      erc['about-what'].should include("Bispectrum", "Nonlinearity", "Epilepsy", "Cooperativity", "Subdural", "Hippocampus")

    end
  end
end

require File.expand_path('../../spec_helper', __FILE__)

module Collector
  class << self
    attr_accessor :output
    
    def write(string)
      @output ||= []
      @output << string
    end
    
    def output
      @output
    end
    
    def reset!
      @output.clear if @output
    end
  end
end

describe "Apprise" do
  xit "should return whether or not all dependencies are up-to-date" do
    Apprise.should.not.be.up_to_date
  end
  
  it "should show all outdated dependencies of the application" do
    Apprise.stubs(:outdated).returns([
      ['rails', 'git'],
      ['forestwatcher', 'svn'],
      ['miso', 'gem']
    ])
    
    collect_stdout do
      Apprise.run
    end.should == <<-OUTPUT
Outdated dependencies

 * rails (Git submodule)
 * forestwatcher (Subversion external)
 * miso (Gem)
OUTPUT
  end
  
  private
  
  def collect_stdout
    Collector.reset!
    before = $stdout
    $stdout = Collector
    yield
    $stdout = before
    Collector.output.join
  end
end
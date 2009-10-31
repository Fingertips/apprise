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
  it "should return the outdated dependencies from the worker classes in alphabetical order" do
    [Apprise::Bundler].each { |klass| klass.stubs(:usable?).returns(true) }
    Apprise::Bundler.stubs(:outdated).returns([['miso', 'gem']])
    
    Apprise::Bundler.outdated.should == [
      ['miso', 'gem']
    ]
  end
  
  it "should print all outdated dependencies" do
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
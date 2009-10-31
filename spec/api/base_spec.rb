require File.expand_path('../../spec_helper', __FILE__)

module Apprise
  class Plugin
    class Foo < Base
    end
  end
end

AVAILABLE_SCMS = Apprise::Plugin.scms.dup
Apprise::Plugin.scms.delete(Apprise::Plugin::Foo)

describe "Apprise::Plugin::Base" do
  before do
    @plugin = Apprise::Plugin::Foo.new(Pathname.new('/some/repo'))
  end
  
  it "should register subclasses as an available scm" do
    AVAILABLE_SCMS.should.include Apprise::Plugin::Foo
  end
  
  it "should return the name of the scm" do
    Apprise::Plugin::Foo.scm.should == 'foo'
  end
  
  it "should initialize with a pathname" do
    @plugin.name.should == 'repo'
  end
  
  it "should compare the current and latest revision to establish whether or not it's up-to-date" do
    @plugin.stubs(:current_revision).returns(42)
    @plugin.stubs(:latest_revision).returns(43)
    @plugin.should.not.be.up_to_date
    
    @plugin.stubs(:latest_revision).returns(42)
    @plugin.should.be.up_to_date
    
    @plugin.stubs(:current_revision).returns('43gj3jjhg4jscs')
    @plugin.stubs(:latest_revision).returns('j4h54bmb3jh2')
    @plugin.should.not.be.up_to_date
    
    @plugin.stubs(:latest_revision).returns('43gj3jjhg4jscs')
    @plugin.should.be.up_to_date
  end
end
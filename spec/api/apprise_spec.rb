require File.expand_path('../../spec_helper', __FILE__)

describe "Apprise" do
  before do
    Apprise::Bundler.stubs(:usable?).returns(true)
    Apprise::Bundler.stubs(:outdated).returns([['miso', 'gem']])
    Apprise::Bundler.stubs(:dependencies).returns([['miso', 'gem']])
    
    Apprise::Plugin.stubs(:all).returns([
      stub('SVN repo', :up_to_date? => false, :name => 'peiji-san', :class => Apprise::Plugin::SVN),
      stub('Git repo', :up_to_date? => true,  :name => 'risosu-san', :class => Apprise::Plugin::Git)
    ])
  end
  
  it "should list all dependencies" do
    Apprise.dependencies.should == [
      ['miso', 'gem'],
      ['peiji-san', 'svn'],
      ['risosu-san', 'git']
    ]
  end
  
  it "should return the outdated dependencies from the worker classes in alphabetical order" do
    Apprise.outdated.should == [
      ['miso', 'gem'],
      ['peiji-san', 'svn']
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
end
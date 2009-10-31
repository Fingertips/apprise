require File.expand_path('../../spec_helper', __FILE__)

describe "Apprise" do
  before do
    Apprise::Bundler.stubs(:usable?).returns(true)
    Apprise::Bundler.stubs(:outdated).returns([['miso', 'gem']])
    Apprise::Bundler.stubs(:dependencies).returns([['miso', 'gem']])
    
    Apprise::Plugin.stubs(:all).returns([
      stub('Git repo', :up_to_date? => true,  :name => 'risosu-san', :class => Apprise::Plugin::Git),
      stub('SVN repo', :up_to_date? => false, :name => 'peiji-san', :class => Apprise::Plugin::SVN)
    ])
  end
  
  it "should use Rails.root if defined" do
    Apprise.send(:discover_root).should == Rails.root
    Apprise.rails_root.should == Rails.root
  end
  
  it "should use the current working directory if Rails is not defined" do
    Object.stubs(:const_defined?).with(:Rails).returns(false)
    
    Dir.chdir '/tmp' do
      Apprise.send(:discover_root).should == Pathname.new(Dir.pwd)
    end
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
      ['forestwatcher', 'svn'],
      ['miso', 'gem'],
      ['rails', 'git']
    ])
    
    collect_stdout do
      Apprise.run
    end.should == <<-OUTPUT
Outdated dependencies
 * forestwatcher (Subversion external)
 * miso (Gem)
 * rails (Git submodule)
OUTPUT
  end
end
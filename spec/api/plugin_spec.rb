# encoding: utf-8

require File.expand_path('../../spec_helper', __FILE__)

describe "Apprise::Plugin" do
  it "should return the plugin root path" do
    root = File.expand_path('../../fixtures/rails_root/vendor/plugins', __FILE__)
    Apprise::Plugin.plugin_root.should == Pathname.new(root)
  end
  
  it "should return an instance for each plugin" do
    checkout_svn_fixture_repo!
    plugins = Apprise::Plugin.all
    plugins.map(&:name).should == %w{ git svn }
    plugins.map(&:class).should == [Apprise::Plugin::Git, Apprise::Plugin::SVN]
  end
  
  it "should return a list of all dependencies" do
    checkout_svn_fixture_repo! and checkout_git_fixture_repo!
    Apprise::Plugin.dependencies.should == [
      ['git', 'git'],
      ['svn', 'svn']
    ]
  end
  
  it "should return a list of outdated plugin repos" do
    svn = checkout_svn_fixture_repo!
    git = checkout_git_fixture_repo!
    
    Apprise::Plugin.outdated.should == [
      ['git', 'git'],
      ['svn', 'svn']
    ]
    
    svn.update!
    Apprise::Plugin.outdated.should == [
      ['git', 'git']
    ]
    
    git.update!
    Apprise::Plugin.outdated.should.be.empty
  end
end
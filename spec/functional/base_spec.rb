require File.expand_path('../../spec_helper', __FILE__)

describe "Apprise::Plugin::Base" do
  it "should add subclasses to the list of available scms" do
    Apprise::Plugin.scms.should == [Apprise::Plugin::Git, Apprise::Plugin::SVN]
  end
  
  it "should return the scm type of a repo" do
    Apprise::Plugin::Git.scm.should == 'git'
    Apprise::Plugin::SVN.scm.should == 'svn'
  end
end
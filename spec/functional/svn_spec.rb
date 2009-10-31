require File.expand_path('../../spec_helper', __FILE__)

describe "Apprise::Plugin::SVN" do
  before do
    checkout_svn_fixture_repo!
    @svn = Apprise::Plugin::SVN.new(svn_checkout)
  end
  
  it "should return whether or not a directory is a svn repo" do
    Apprise::Plugin::SVN.should.be.repo svn_checkout
    Apprise::Plugin::SVN.should.not.be.repo git_checkout
  end
  
  it "should return it's name" do
    @svn.name.should == 'svn'
  end
  
  it "should return the URL to the repo" do
    @svn.url.should == svn_repo
  end
  
  it "should return the latest upstream revision" do
    @svn.latest_revision.should == 2
  end
  
  it "should return the current checked out revision" do
    @svn.current_revision.should == 1
  end
  
  it "should check whether or not a subversion repo is up to date" do
    @svn.should.not.be.up_to_date
  end
  
  it "should update the checkout" do
    @svn.update!
    @svn.should.be.up_to_date
  end
end
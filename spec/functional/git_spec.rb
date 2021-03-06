# encoding: utf-8

require File.expand_path('../../spec_helper', __FILE__)

describe "Apprise::Plugin::Git" do
  before do
    @git = checkout_git_fixture_repo!
  end
  
  it "should return whether or not a directory is a git repo" do
    Apprise::Plugin::Git.should.be.repo git_checkout
    Apprise::Plugin::Git.should.not.be.repo svn_checkout
  end
  
  it "should return it's name" do
    @git.name.should == 'git'
  end
  
  it "should return the current branch" do
    @git.current_branch.should == 'master'
  end
  
  it "should return the current remote" do
    @git.current_remote.should == 'origin'
  end
  
  it "should return the latest upstream revision" do
    @git.latest_revision.should == '99f3375eeb69a82bc282a4638cdd4380691db7e7'
  end
  
  it "should return the current checked out revision" do
    @git.current_revision.should == 'b200b30bcf41e674b8c1bd013316498dfa193077'
  end
  
  it "should check whether or not the checkout up to date" do
    @git.should.not.be.up_to_date
  end
  
  it "should update the checkout" do
    @git.update!
    @git.should.be.up_to_date
  end
end
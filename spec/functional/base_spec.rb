require File.expand_path('../../spec_helper', __FILE__)

describe "Apprise::Plugin::Base" do
  it "should add subclasses to the list of available scms" do
    Apprise::Plugin.scms.should == [Apprise::Plugin::Git, Apprise::Plugin::SVN]
  end
end
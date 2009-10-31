require File.expand_path('../../spec_helper', __FILE__)

if Apprise::Bundler.usable?
  describe "Apprise::Bundler" do
    it "should return outdated gems" do
      Apprise::Bundler.outdated.should == []
    end
  end
end
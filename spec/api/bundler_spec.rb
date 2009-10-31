require File.expand_path('../../spec_helper', __FILE__)

if Apprise::Bundler.usable?
  describe "Apprise::Bundler" do
    it "should return the gemfile path" do
      Apprise::Bundler.gemfile_path.should == Pathname.new(File.expand_path('../../fixtures/rails_root/Gemfile', __FILE__))
    end
  
    it "should return outdated gems if bundler finds outdated gems" do
      Apprise::Bundler.outdated.should == []
    end
  
    it "should not return outdated gems if there are no outdated gems" do
      Bundler::Environment.any_instance.stubs(:repository).returns(mock('Repository', :outdated_gems => [
        'miso', 'rack', 'rails'
      ]))
      Apprise::Bundler.outdated.should == [
        ['miso', 'gem'],
        ['rack', 'gem'],
        ['rails', 'gem']
      ]
    end
  end
end
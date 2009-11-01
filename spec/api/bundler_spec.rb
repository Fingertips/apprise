require File.expand_path('../../spec_helper', __FILE__)

if Apprise::Bundler.usable?
  describe "Apprise::Bundler" do
    it "should return all dependencies" do
      Apprise::Bundler.stubs(:gem_dependencies).returns([
        stub(:name => 'miso'),
        stub(:name => 'rack'),
        stub(:name => 'rails')
      ])
      Apprise::Bundler.dependencies.should == [
        ['miso', 'gem'],
        ['rack', 'gem'],
        ['rails', 'gem']
      ]
    end
    
    it "should return the gemfile path" do
      Apprise::Bundler.gemfile_path.should == Pathname.new(File.expand_path('../../fixtures/rails_root/Gemfile', __FILE__))
    end
  
    it "should not return outdated gems if there are no outdated gems" do
      Apprise::Bundler.outdated.should == []
    end
    
    it "should return outdated gems if bundler finds outdated gems" do
      Apprise::Bundler.stubs(:repository).returns(mock('Repository', :outdated_gems => [
        'miso', 'rack', 'rails'
      ]))
      Apprise::Bundler.outdated.should == [
        ['miso', 'gem'],
        ['rack', 'gem'],
        ['rails', 'gem']
      ]
    end
    
    it "should not return dependencies if there are no dependencies" do
      Apprise::Bundler.stubs(:gem_dependencies).returns([])
      Apprise::Bundler.dependencies.should == []
    end
    
    it "should return dependencies if bundler finds dependencies" do
      Apprise::Bundler.stubs(:gem_dependencies).returns([
        mock(:name => 'miso'), mock(:name => 'rack'), mock(:name => 'rails')
      ])
      Apprise::Bundler.dependencies.should == [
        ['miso', 'gem'],
        ['rack', 'gem'],
        ['rails', 'gem']
      ]
    end
  end
end
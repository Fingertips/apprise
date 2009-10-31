require File.expand_path('../spec_helper', __FILE__)

describe "Apprise::Plugin" do
  it "should return the plugin root path" do
    Apprise::Plugin.plugin_root.should == Rails.root + 'vendor/plugins'
  end
  
  it "should return an instance for each plugin" do
    plugins = Apprise::Plugin.all
    plugins.map(&:name).should == %w{ authorization-san peiji-san }
  end
end
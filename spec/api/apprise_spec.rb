require File.expand_path('../../spec_helper', __FILE__)

describe "Apprise" do
  xit "should return whether or not all dependencies are up-to-date" do
    Apprise.should.not.be.up_to_date
  end
end
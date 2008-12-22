require File.dirname(__FILE__) + "/../spec_helper"

describe QueryAnalyzer do
  before(:each) do
    QueryAnalyzer.reset_logging!
  end

  it "should have logging on by default" do
    QueryAnalyzer.logging.should be_true
  end

  it "should be able to set logging to false" do
    QueryAnalyzer.logging = false
    QueryAnalyzer.logging.should be_false
  end

  it "should be able to reset the logs" do
    QueryAnalyzer.reset_logging!
    QueryAnalyzer.logging.should be_true
  end
end

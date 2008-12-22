require File.dirname(__FILE__) + "/../spec_helper"

describe EnhancedQueryAnalyzer do
  before(:each) do
    EnhancedQueryAnalyzer.reset_logging!
  end

  it "should have logging on by default" do
    EnhancedQueryAnalyzer.logging.should be_true
  end

  it "should be able to set logging to false" do
    EnhancedQueryAnalyzer.logging = false
    EnhancedQueryAnalyzer.logging.should be_false
  end

  it "should be able to reset the logs" do
    EnhancedQueryAnalyzer.reset_logging!
    EnhancedQueryAnalyzer.logging.should be_true
  end
end

require File.dirname(__FILE__) + "/../spec_helper"

describe "Running a select query" do
  before(:each) do
    EnhancedQueryAnalyzer.reset_logging!
    QueryLog.destroy_all
  end

  it "should create an entry in the query log" do
    lambda { 
      User.find_by_sql <<-SQL
        SELECT * FROM users
      SQL
    }.should change(QueryLog, :count).by(1)
  end

  it "should not create an entry for an 'explain'" do
    lambda { 
      User.find_by_sql <<-SQL
         EXPLAIN select * from users
      SQL
    }.should_not change(QueryLog, :count)
  end

  it "should not create an extry with a lowercase explain" do
    lambda { 
      User.find_by_sql <<-SQL
         explain select * from users
      SQL
    }.should_not change(QueryLog, :count)
  end

  it "should store the query" do
    User.find_by_sql "SELECT * FROM users"
    QueryLog.find(:first).query.should == "SELECT * FROM users"
  end

  def read_fixture(file)
    File.read("#{File.dirname(__FILE__)}/fixtures/#{file}")
  end

  it "should store the explain" do
    User.find_by_sql "SELECT * FROM users"
    output = read_fixture("typical_output")
    QueryLog.find(:first).explain.should == output
  end

  it "should not create an entry if logging is turned off" do
    EnhancedQueryAnalyzer.logging = false
    lambda {
      User.find_by_sql <<-SQL
        SELECT * FROM users
      SQL
    }.should_not change(QueryLog, :count)
  end

  it "should record the query time" do
    User.find(:first)
    QueryLog.find(:first).query_time.should_not be_nil
  end

  it "should still return the result even if the QueryLog raises an error" do
    QueryLog.stub!(:create).and_raise Mysql::Error
    User.find(:all).should == []
  end
end
require File.dirname(__FILE__) + "/../spec_helper"

describe "Running a select query" do
  before(:each) do
    EnhancedQueryAnalyzer.reset!
    QueryLog.destroy_all
    User.delete_all
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

  it "should not create an entry if logging is turned off" do
    EnhancedQueryAnalyzer.log_if { |query, time| false }
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

  it "should still return the result even if the QueryLog raises a ActiveRecord::StatementInvalid error (because the table doesn't exist yet)" do
    QueryLog.stub!(:create).and_raise(ActiveRecord::StatementInvalid)
    User.find(:all).should == []
  end

  it "should not log queries to the query_logs table" do
    lambda {
      QueryLog.find(:first)
    }.should_not change(QueryLog, :count)
  end

  it "should not log the query if the query isn't a select" do
    lambda {
      User.create!
    }.should_not change(QueryLog, :count)
  end

  it "should not log the explain if explain is turned off (true by default)" do
    User.find(:first)
    QueryLog.find(:first).explain.should be_nil
  end

  it "should not log the explain if explain is turned off (explicitly)" do
    EnhancedQueryAnalyzer.explain_logging = false
    User.find(:first)
    QueryLog.find(:first).explain.should be_nil
  end

  it "should store the explain when explain_logging = true" do
    EnhancedQueryAnalyzer.explain_logging = true

    User.find_by_sql "SELECT * FROM users"
    output = read_fixture("typical_output")
    QueryLog.find(:first).explain.should == output
  end

  describe "logging conditionally" do
    it "should not log a query if the logging conditions say it's false" do
      lambda {
        EnhancedQueryAnalyzer.log_if { |_, _| false }
        User.find_by_sql "SELECT * FROM users"
      }.should_not change { QueryLog.count }
    end

    it "should yield the query to the block" do
      query = nil

      EnhancedQueryAnalyzer.log_if { |query_given, _| query = query_given }

      User.find_by_sql "SELECT * FROM users"

      query.should == "SELECT * FROM users"
    end

    it "should yield the time to the block" do
      time = nil

      EnhancedQueryAnalyzer.log_if { |_, time_given| time = time_given }

      User.find_by_sql "SELECT * FROM users"

      time.to_s[0..5].should == QueryLog.find(:first).query_time.to_s[0..5]
    end
  end

  describe "regressions" do
    it "should store the entire query (not a truncated version)" do
      EnhancedQueryAnalyzer.explain_logging = true

      query = <<-SQL
        SELECT * FROM users
        WHERE
          first_name = 'foobarbazfoobarbazfoobarbazfoobarbazfoobarbaz' OR
          first_name = 'foobarbazfoobarbazfoobarbazfoobarbazfoobarbaz' OR
          first_name = 'somereallyreallylongname'
        ORDER BY first_name
        LIMIT 3
      SQL

      User.find_by_sql(query)
      QueryLog.find(:first).query.should == query
    end

    it "should store the entire explain" do
      explain_text = "explain" * 100

      QueryLog.create!(:explain => explain_text)
      QueryLog.find(:first).explain.should == explain_text
    end
  end
end

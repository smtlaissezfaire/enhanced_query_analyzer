require File.dirname(__FILE__) + "/../spec_helper"

describe "Running a select query" do
  before(:each) do
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

  it "should store the explain" do
    User.find_by_sql "SELECT * FROM users"
    output = "select_type | key_len | type | Extra | id | possible_keys | rows | table | ref | key
   ------------------------------------------------------------------------------------
   SIMPLE      |         | ALL  |       | 1  |               | 1    | users |     "

    QueryLog.find(:first).explain.should == output
  end
end

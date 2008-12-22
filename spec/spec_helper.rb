require "rubygems"
require "spec"
require "active_support"
require "active_record"

module SpecHelperFunctions
  def setup_specs
    setup_database_connection
  end
  
private
  
  def setup_database_connection
    ActiveRecord::Base.establish_connection({ 
      :adapter => 'mysql',
      :database  => 'query_analyzer_test',
      :user => "root",
      :password => ""
    })

    ActiveRecord::Schema.define do  
      create_table :users, :force => true do |t|
        t.string :first_name
        t.timestamps
      end

      create_table :query_logs, :force => true do |t|
        t.string :query
        t.string :explain
        t.timestamps
      end
    end
  end
end

Spec::Runner.configure do |config|
  include SpecHelperFunctions
  setup_specs
end

require File.dirname(__FILE__) + '/../init'

class User < ActiveRecord::Base; end
class QueryLog < ActiveRecord::Base; end

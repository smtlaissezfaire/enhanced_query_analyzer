require File.dirname(__FILE__) + "/enhanced_query_analyzer/select_proxy"
require File.dirname(__FILE__) + "/enhanced_query_analyzer/logging"
require File.dirname(__FILE__) + "/enhanced_query_analyzer/select_runner"

module EnhancedQueryAnalyzer
  extend Logging
  extend SelectProxy
end

ActiveRecord::ConnectionAdapters::MysqlAdapter.class_eval do
  public :select
  alias_method :old_select_aliased_by_query_analyzer, :select

  def select(sql, name = nil)
    EnhancedQueryAnalyzer.select(self, sql, name)
  end
end

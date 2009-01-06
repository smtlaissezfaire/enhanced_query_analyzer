require File.dirname(__FILE__) + "/lib/enhanced_query_analyzer"

ActiveRecord::ConnectionAdapters::MysqlAdapter.class_eval do
  if !instance_methods.include?("old_select_aliased_by_query_analyzer")
    public :select
    alias_method :old_select_aliased_by_query_analyzer, :select

    def select(sql, name = nil)
      EnhancedQueryAnalyzer.select(self, sql, name)
    end
  end
end

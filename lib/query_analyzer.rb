ActiveRecord::ConnectionAdapters::MysqlAdapter.class_eval do
  alias_method :old_select_aliased_by_query_analyzer, :select

  def select(sql, name = nil)
    result = old_select_aliased_by_query_analyzer(sql, name)

    if !(sql =~ /.*(explain|query_logs).*/i)
      explain_output = select("explain #{sql}")
      
      QueryLog.create!(:query => sql, :explain => explain_output)
    end
    
    result
  end
end

ActiveRecord::ConnectionAdapters::MysqlAdapter.class_eval do
  alias_method :old_select_aliased_by_query_analyzer, :select

  def select(sql, name = nil)
    result = old_select_aliased_by_query_analyzer(sql, name)

    if !(sql =~ /.*(explain|query_logs).*/i)
      QueryLog.create!(:query => sql, :explain => select("explain #{sql}"))
    end
    
    result
  end
end

module QueryAnalyzer
  class << self
    attr_writer :logging

    def logging
      @logging = true if @logging.equal? nil
      @logging
    end

    def reset_logging!
      @logging = nil
    end
  end
end

ActiveRecord::ConnectionAdapters::MysqlAdapter.class_eval do
  alias_method :old_select_aliased_by_query_analyzer, :select

  def select(sql, name = nil)
    result = old_select_aliased_by_query_analyzer(sql, name)

    if QueryAnalyzer.logging && !(sql =~ /.*(explain|query_logs).*/i)
      QueryLog.create!(:query => sql, :explain => select("explain #{sql}"))
    end
    
    result
  end
end

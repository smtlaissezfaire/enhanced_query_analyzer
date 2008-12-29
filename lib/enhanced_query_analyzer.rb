module EnhancedQueryAnalyzer
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
    if EnhancedQueryAnalyzer.logging && !(sql =~ /.*(explain|query_logs).*/i)
      result = nil
      time = Benchmark.realtime do
        result = old_select_aliased_by_query_analyzer(sql, name)
      end

      if sql =~ /select/i
        begin
          QueryLog.create(:query => sql, :explain => old_select_aliased_by_query_analyzer("explain #{sql}"), :query_time => time)
        rescue Mysql::Error; end
      end
      
      result
    else
      old_select_aliased_by_query_analyzer(sql, name)
    end
  end
end

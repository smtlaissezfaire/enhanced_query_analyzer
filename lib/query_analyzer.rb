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
    if QueryAnalyzer.logging && !(sql =~ /.*(explain|query_logs).*/i)
      result = nil
      time = Benchmark.realtime do
        result = old_select_aliased_by_query_analyzer(sql, name)
      end

      QueryLog.create!(:query => sql, :explain => select("explain #{sql}"), :query_time => time)
      result
    else
      old_select_aliased_by_query_analyzer(sql, name)
    end
  end
end

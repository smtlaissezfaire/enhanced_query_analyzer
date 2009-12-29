module EnhancedQueryAnalyzer
  class SelectRunner
    def initialize(adapter, logging_on, explain_logging_on, log_conditions)
      @adapter            = adapter
      @logging_on         = logging_on
      @explain_logging_on = explain_logging_on
      @log_conditions     = log_conditions
    end

    attr_reader :logging_on

    def logging_on?
      @logging_on ? true : false
    end

    def explain_logging_on?
      @explain_logging_on ? true : false
    end

    def run_query(sql, name = nil)
      @adapter.old_select_aliased_by_query_analyzer(sql, name)
    end

    def select(sql, name)
      result = nil
      time = Benchmark.realtime do
        result = run_query(sql, name)
      end

      if log_query?(sql, time)
        save_logged_query_time(sql, time)
      end

      result
    end

  private

    def save_logged_query_time(sql, time)
      if select_query?(sql)
        begin
          QueryLog.create(:query => sql, :explain => explain(sql), :query_time => time)
        rescue ActiveRecord::StatementInvalid; end
      end
    end

    def explain(sql)
      explain_logging_on? ? run_query("explain #{sql}") : nil
    end

    def log_query?(sql, time)
      logging_on? && table_for_selection?(sql) && @log_conditions.call(sql, time)
    end

    def table_for_selection?(sql)
      !(sql =~ /.*(explain|query_logs).*/i)
    end

    def select_query?(sql)
      sql =~ /select/i
    end
  end
end

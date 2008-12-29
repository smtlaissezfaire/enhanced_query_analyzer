module EnhancedQueryAnalyzer
  module Logging
    attr_writer :logging, :explain_logging

    def explain_logging
      @explain_logging ||= false
    end

    def logging
      @logging = true if @logging.equal? nil
      @logging
    end

    def reset_logging!
      @logging = nil
      @explain_logging = nil
    end
  end

  module SelectProxy
    def select(adapter, sql, name)
      SelectRunner.new(adapter, logging, explain_logging).select(sql, name)
    end
  end

  extend Logging
  extend SelectProxy

  class SelectRunner
    def initialize(adapter, logging_on, explain_logging_on)
      @adapter = adapter
      @logging_on = logging_on
      @explain_logging_on = explain_logging_on
    end

    attr_reader :logging_on

    def logging_on?
      @logging_on ? true : false
    end

    def explain_logging_on?
      @explain_logging_on ? true : false
    end

    def select(sql, name)
      if log_query?(sql)
        benchmark_and_run_query(sql, name)
      else
        run_query(sql, name)
      end
    end

    def run_query(sql, name = nil)
      @adapter.old_select_aliased_by_query_analyzer(sql, name)
    end

    def benchmark_and_run_query(sql, name)
      result = nil
      time = Benchmark.realtime do
        result = run_query(sql, name)
      end

      save_logged_query_time(sql, time)

      result
    end

  private

    def save_logged_query_time(sql, time)
      if select_query?(sql)
        begin
          QueryLog.create(:query => sql, :explain => explain(sql), :query_time => time)
        rescue Mysql::Error; end
      end
    end

    def explain(sql)
      explain_logging_on? ? run_query("explain #{sql}") : nil
    end

    def log_query?(sql)
      logging_on? && table_for_selection?(sql)
    end

    def table_for_selection?(sql)
      !(sql =~ /.*(explain|query_logs).*/i)
    end

    def select_query?(sql)
      sql =~ /select/i
    end
  end
end

ActiveRecord::ConnectionAdapters::MysqlAdapter.class_eval do
  public :select
  alias_method :old_select_aliased_by_query_analyzer, :select

  def select(sql, name = nil)
    EnhancedQueryAnalyzer.select(self, sql, name)
  end
end

module EnhancedQueryAnalyzer
  module Logging
    attr_writer :explain_logging

    def explain_logging
      @explain_logging ||= false
    end

    def slow_query_time
      @slow_query_time ||= nil
    end

    attr_writer :slow_query_time

    def log_query?(query, time)
      logging_conditions.call(query, time)
    end

    def logging_conditions
      @logging_conditions ||= lambda { |_, _| true }
    end

    def log_if(&block)
      @logging_conditions = block
    end

    def reset!
      @explain_logging    = nil
      @logging_conditions = lambda { |_, _| true }
    end
  end
end

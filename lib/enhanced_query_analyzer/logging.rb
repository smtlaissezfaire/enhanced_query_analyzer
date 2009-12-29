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
      @logging            = nil
      @explain_logging    = nil
      @logging_conditions = lambda { |_, _| true }
    end
  end
end

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

    def reset!
      @logging         = nil
      @explain_logging = nil
    end
  end
end

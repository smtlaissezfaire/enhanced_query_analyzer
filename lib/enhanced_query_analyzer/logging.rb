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

    def reset!
      @logging         = nil
      @explain_logging = nil
    end
  end
end

module EnhancedQueryAnalyzer
  module SelectProxy
    def select(adapter, sql, name)
      SelectRunner.new(adapter, logging, explain_logging, logging_conditions).select(sql, name)
    end
  end
end


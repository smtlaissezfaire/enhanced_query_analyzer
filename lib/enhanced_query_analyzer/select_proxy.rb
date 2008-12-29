module EnhancedQueryAnalyzer
  module SelectProxy
    def select(adapter, sql, name)
      SelectRunner.new(adapter, logging, explain_logging).select(sql, name)
    end
  end
end


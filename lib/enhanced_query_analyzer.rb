require File.dirname(__FILE__) + "/enhanced_query_analyzer/select_proxy"
require File.dirname(__FILE__) + "/enhanced_query_analyzer/logging"
require File.dirname(__FILE__) + "/enhanced_query_analyzer/select_runner"

module EnhancedQueryAnalyzer
  extend Logging
  extend SelectProxy
end

require File.dirname(__FILE__) + "/enhanced_query_analyzer/logging"
require File.dirname(__FILE__) + "/enhanced_query_analyzer/select_runner"
require File.dirname(__FILE__) + "/enhanced_query_analyzer/select_proxy"

module EnhancedQueryAnalyzer
  extend Logging
  extend SelectProxy
end

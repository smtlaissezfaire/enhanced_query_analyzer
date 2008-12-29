
dir = File.dirname(__FILE__) + "/enhanced_query_analyzer"
require "#{dir}/logging"
require "#{dir}/select_runner"
require "#{dir}/select_proxy"

module EnhancedQueryAnalyzer
  extend Logging
  extend SelectProxy
end

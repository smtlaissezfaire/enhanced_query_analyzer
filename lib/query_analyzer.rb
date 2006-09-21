class Array
  protected
    def columnized_row(fields, sized)
      r = []
      fields.each_with_index do |f, i|
        r << sprintf("%0-#{sized[i]}s", f.to_s.gsub(/\n|\r/, '').slice(0, sized[i]))
      end
      r.join(' | ')
    end

  public

  def columnized(options = {})
    sized = {}
    self.each do |row|
      row.values.each_with_index do |value, i|
        sized[i] = [sized[i].to_i, row.keys[i].length, value.to_s.length].max
      end
    end

    table = []
    table << header = columnized_row(self.first.keys, sized)
    table << header.gsub(/./, '-')
    self.each { |row| table << columnized_row(row.values, sized) }
    table.join("\n")
  end
end



module ActiveRecord
  module ConnectionAdapters
    class MysqlAdapter < AbstractAdapter
      private
        # Alias the select method to our own
        alias_method :select_without_analyzer, :select
        
        def select(sql, name = nil)
          query_results = select_without_analyzer(sql, name)
          
          if @logger and @logger.level <= Logger::INFO
            analyzer_results = []
            @logger.silence do
              analyzer_results = select_without_analyzer("explain " << sql, name)
            end
            @logger.debug(format_log_entry("\e[7mAnalyzing #{name}\e[0m\n", ''))
            @logger.debug(analyzer_results.columnized + "\n\n")
          end
          
          query_results
        end
    end
  end
end

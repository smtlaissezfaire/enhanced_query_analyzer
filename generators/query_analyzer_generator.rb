class QueryAnalyzerGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "models/query_log.rb", "app/models/query_log.rb"
      m.migration_template "migrate/create_query_log.rb", "db/migrate", { 
        :migration_file_name => 'create_query_log',
      }
    end
  end
end

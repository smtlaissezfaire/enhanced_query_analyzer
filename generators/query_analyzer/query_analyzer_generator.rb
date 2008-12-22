class QueryAnalyzerGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "models/query_log.rb", "app/models/query_log.rb"
      m.migration_template "migrate/create_query_log.rb", "db/migrate", {
        :migration_file_name => 'create_query_log',
        :assigns => yaffle_local_assigns
      }
    end
  end

  def class_name
    "QueryLog"
  end

  def custom_file_name
    custom_name = class_name.underscore.downcase
    custom_name = custom_name.pluralize if ActiveRecord::Base.pluralize_table_names
  end

  def yaffle_local_assigns
    returning(assigns = {}) do
      assigns[:migration_action] = "create"
      assigns[:table_name] = custom_file_name
      assigns[:attributes] = [Rails::Generator::GeneratedAttribute.new(:query, :string)]
      assigns[:attributes] << Rails::Generator::GeneratedAttribute.new(:query_time, :float)
      assigns[:attributes] << Rails::Generator::GeneratedAttribute.new(:explain, :string)
      assigns[:attributes] << Rails::Generator::GeneratedAttribute.new(:created_at, :datetime)
      assigns[:attributes] << Rails::Generator::GeneratedAttribute.new(:updated_at, :datetime)
    end
  end
end

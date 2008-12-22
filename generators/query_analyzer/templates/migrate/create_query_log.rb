class CreateQueryLog < ActiveRecord::Migration
  def self.up
    create_table :query_logs, :force => true do |t|
      t.string :query
      t.float  :query_time
      t.string :explain
      t.timestamps
    end
  end

  def self.down
    drop_table :query_logs
  end
end

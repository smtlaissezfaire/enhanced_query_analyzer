class CreateQueryLog < ActiveRecord::Migration
  def self.up
    create_table :query_logs, :options => 'ENGINE=Archive' do |t|
      t.text   :query
      t.float  :query_time
      t.string :explain
      t.timestamps
    end
  end

  def self.down
    drop_table :query_logs
  end
end

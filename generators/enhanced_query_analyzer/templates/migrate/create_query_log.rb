class CreateQueryLog < ActiveRecord::Migration
  def self.up
    create_table :query_logs, :options => 'ENGINE=MyISAM' do |t|
      t.text   :query
      t.float  :query_time
      t.text   :explain
      t.timestamps
    end
  end

  def self.down
    drop_table :query_logs
  end
end

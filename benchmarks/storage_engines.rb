require "rubygems"
require "benchmark"
require "active_support"
require "active_record"

TIMES = 10_000

ActiveRecord::Base.establish_connection({ 
  :adapter => 'mysql',
  :database  => 'query_analyzer_test',
  :user => "root",
  :password => ""
})

ActiveRecord::Schema.define do  

  create_table :innodb, :force => true, :options => 'ENGINE=InnoDB' do |t|
    t.string :foo
  end
  
  create_table :myisam, :force => true, :options => 'ENGINE=MyISAM' do |t|
    t.string :foo
  end
  
  create_table :archive, :force => true, :options => 'ENGINE=Archive' do |t|
    t.string :foo
  end

end

class InnoDB < ActiveRecord::Base
  set_table_name :innodb
end

class MyISAM < ActiveRecord::Base
  set_table_name :myisam
end

class Archive < ActiveRecord::Base
  set_table_name :archive
end

class String
  def self.random(length=10)
    chars = ("a".."z").to_a
    string = ""
    1.upto(length) { |i| string << chars[rand(chars.size-1)]}
    return string
  end
end

Benchmark.bm do |b|
  b.report "inserts with innodb storage engine" do
    TIMES.times { InnoDB.create!(:foo => String.random) }
  end

  b.report "inserts with myisam storage engine" do 
    TIMES.times { MyISAM.create!(:foo => String.random) }
  end

  b.report "inserts with archive storage engine" do
    TIMES.times { Archive.create!(:foo => String.random) }
  end
end

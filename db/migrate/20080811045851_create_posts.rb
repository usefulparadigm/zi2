class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
	    t.string   "title"
	    t.text     "content"
	    t.integer  "read_count",        :default => 0
	    t.integer  "comments_count",    :default => 0
	    t.integer  "diggs_count",       :default => 0
	    t.integer  "clips_count", :default => 0
	    t.boolean  "sticky", :default => false
			t.column	:ip, :string, :limit => 24
			t.column	:url, :string
      t.timestamps
	    t.integer  "user_id"
	    t.integer  "board_id"
    end
  end

  def self.down
    drop_table :posts
  end
end

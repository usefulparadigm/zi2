class CreateReplies < ActiveRecord::Migration
  def self.up
    create_table :replies do |t|
      t.text :body
      t.string :ip, :limit => 15
      t.integer :user_id, :post_id
      t.string :author, :password, :homepage
			t.boolean :secret, :defalut => false
      t.timestamps
    end
  end

  def self.down
    drop_table :replies
  end
end

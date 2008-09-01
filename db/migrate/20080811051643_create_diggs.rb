class CreateDiggs < ActiveRecord::Migration
  def self.up
    create_table :diggs do |t|
      t.integer :user_id
      t.integer :post_id
			t.string :ip, :limit => 24
      t.timestamps
    end
  end

  def self.down
    drop_table :diggs
  end
end

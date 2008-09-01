class CreateBoards < ActiveRecord::Migration
  def self.up
    create_table :boards do |t|
      t.string :title
      t.string :name
      t.text :description
      t.integer :group_id
      t.integer :posts_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :boards
  end
end

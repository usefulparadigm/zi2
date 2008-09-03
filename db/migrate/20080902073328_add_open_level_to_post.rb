class AddOpenLevelToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :open_level, :integer, :default => 99
  end

  def self.down
    remove_column :posts, :open_level
  end
end

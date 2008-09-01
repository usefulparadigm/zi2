class ChangeCommentsCountToRepliesCountForPost < ActiveRecord::Migration
  def self.up
  	rename_column :posts, :comments_count, :replies_count
  end

  def self.down
  	rename_column :posts, :replies_count, :comments_count
  end
end

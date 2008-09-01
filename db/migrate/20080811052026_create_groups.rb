class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :title
      t.string :name
      t.text :description
      t.integer :boards_count, :default => 0

      t.timestamps
    end
    
    # Create default 'home' group
    Group.create :name => 'home', :title => 'Home'
  end

  def self.down
    drop_table :groups
  end
end

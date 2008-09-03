class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.integer :user_id
      t.integer :role_id

      t.timestamps
    end
    remove_column :users, :admin
    admin = User.first
    admin_role = Role.create(:name => 'admin', :description => 'Admin')
    Permission.create :user => admin, :role => admin_role
  end

  def self.down
    drop_table :permissions
    add_column :users, :admin, :boolean, :default => false
  end
end

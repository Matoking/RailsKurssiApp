class AddFrozenAccessToUser < ActiveRecord::Migration
  def change
    add_column :users, :frozen_access, :boolean
  end
end

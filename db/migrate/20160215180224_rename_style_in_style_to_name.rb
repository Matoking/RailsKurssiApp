class RenameStyleInStyleToName < ActiveRecord::Migration
  def change
      rename_column :styles, :style, :name
  end
end

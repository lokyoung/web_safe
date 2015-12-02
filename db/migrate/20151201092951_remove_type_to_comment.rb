class RemoveTypeToComment < ActiveRecord::Migration
  def change
    remove_column :comments, :type, :string
  end
end

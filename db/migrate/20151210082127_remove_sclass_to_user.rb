class RemoveSclassToUser < ActiveRecord::Migration
  def change
    remove_column :users, :sclass, :string
  end
end

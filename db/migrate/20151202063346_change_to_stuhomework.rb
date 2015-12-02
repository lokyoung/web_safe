class ChangeToStuhomework < ActiveRecord::Migration
  def change
    remove_column :stuhomeworks, :comment, :string
    add_column :stuhomeworks, :remark, :text
  end
end

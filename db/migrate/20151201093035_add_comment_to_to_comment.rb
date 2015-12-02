class AddCommentToToComment < ActiveRecord::Migration
  def change
    add_column :comments, :comment_to, :string
  end
end

class AddIsVideoToCoursewares < ActiveRecord::Migration
  def change
    remove_column :coursewares, :filetpye
    add_column :coursewares, :isvideo, :boolean, default: false
  end
end

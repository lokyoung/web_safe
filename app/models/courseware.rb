class Courseware < ActiveRecord::Base
  belongs_to :user
  mount_uploader :coursefile, CourseFileUploader
  validates_presence_of :title, :description, :coursefile
end

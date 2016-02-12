class Courseware < ApplicationRecord
  belongs_to :user
  mount_uploader :coursefile, CourseFileUploader
  validates_presence_of :title, :description, :coursefile
end

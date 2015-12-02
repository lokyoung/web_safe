class Courseware < ActiveRecord::Base
  belongs_to :user
  mount_uploader :coursefile, CourseFileUploader
  validates :title, presence: true
  validates :description, presence: true
end

class Stuhomework < ActiveRecord::Base
  belongs_to :user
  belongs_to :homework
  mount_uploader :stuhomeworkfile, StuHomeWorkUploader
  validates :stuhomeworkfile, presence: true
end

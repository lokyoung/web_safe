class Homework < ActiveRecord::Base
  belongs_to :user
  has_many :stuhomeworks
  mount_uploader :homeworkfile, HomeworkfileUploader

  # 作业和班级是多对多关系，当作业删除时，被删除作业和对应班级之间关系也被删除
  has_and_belongs_to_many :stuclasses, dependent: :nullify
end

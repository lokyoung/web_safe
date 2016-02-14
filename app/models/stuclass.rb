class Stuclass < ApplicationRecord
  has_many :students, dependent: :nullify
  # 班级和作业是多对多关系，班级删除时，班级和作业之间的关系也随之删除
  has_and_belongs_to_many :homeworks, dependent: :nullify
  has_and_belongs_to_many :experiments, dependent: :nullify

  def name_with_initial
    "#{scname}"
  end
end

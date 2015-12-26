class Experiment < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :stuclasses, dependent: :nullify
  mount_uploader :experimentfile, ExperimentfileUploader
end

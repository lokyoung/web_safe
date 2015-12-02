class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer
  belongs_to :topic

  validates :user_id, presence: true
  validates :content, presence: true
end

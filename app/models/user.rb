class User < ApplicationRecord
  include LetterAvatar::AvatarHelper

  attr_accessor :remember_token
  # 用户和公告是一对多的关系，同时如果和公告相关的用户被删除了，对应的公告也会被删除。
  has_many :announces, dependent: :destroy
  # 用户和问题是一对多关系
  has_many :questions, dependent: :destroy
  # 用户和回答是一对多关系
  has_many :answers, dependent: :destroy
  # 用户(教师)和课件是一对多关系
  has_many :coursewares, dependent: :destroy
  # 用户(教师)和布置的作业是一对多关系
  has_many :homeworks, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :stuhomeworks, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :experiments, dependent: :destroy

  # 用户和关注关系
  #has_many :active_relationships, class_name: "Relationship",
                                  #foreign_key: "follower_id",
                                  #dependent: :destroy
  #has_many :passive_relationships, class_name: "Relationship",
                                   #foreign_key: "followed_id",
                                   #dependent: :destroy
  #has_many :following, through: :active_relationships, source: :followed
  #has_many :followers, through: :passive_relationships, source: :follower

  before_save { self.email = email.downcase }
  # 方法最后一个参数为哈希，花括号可以省略
  # validates :name, { presence: true }
  validates :name, presence: true, length: { maximum: 20 },
                   uniqueness: true
  VALID_EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_FORMAT },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true
  def username_for_avatar
    # Translate chinese hanzi to pinyin
    # https://github.com/flyerhzm/chinese_pinyin
    Pinyin.t(name)
  end

  def avatar_url
    letter_avatar_for(username_for_avatar, 200).sub('public/', '/')
  end

  # 返回指定字符串的哈希摘要
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # 返回随机令牌
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 记住用户
  def remember
    # 如果没有写上self，会创建一个名为remember_token的本地变量
    # 我们要将值赋给用户的remember_token属性，所以要写上self
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # 忘记用户
  def forget
    update_attribute(:remember_digest, nil)
  end

  def self.inherited(child)
     child.instance_eval do
       def model_name
          User.model_name
       end
     end
     super
  end

  # 关注用户
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # 取消关注
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 判断是否关注了用户
  def following?(other_user)
    following.include?(other_user)
  end

end

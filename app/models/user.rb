class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  
  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true, length: {maximum: 50}
  validates :password, presence: true, on: :create, length: {minimum: 5, maximum: 50}

  include Sluggable
  sluggable_column :username

  def admin?
    self.role == 'admin'
  end

  def moderator?
    self.role == 'moderator'
  end
end

class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  attr_accessor :login

  # Override find_for_database_authentication to allow login with email or username
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      user = where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
      Rails.logger.debug "DEBUG: Finding user with login: #{login}. Found: #{user&.username}"
      user
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  # === Associations ===

  # Tweets
  has_many :tweets, dependent: :destroy

  # Comments
  has_many :comments, dependent: :destroy

  # Likes
  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet

  # Follow system - Self-referential associations
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy

  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # === Validations ===
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 20 },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "sadece harf, rakam ve alt çizgi içerebilir" }

  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "geçerli bir e-posta adresi olmalıdır" }

  validates :display_name, length: { maximum: 50 }
  validates :bio, length: { maximum: 160 }

  # === Methods ===

  # Follow a user
  def follow(other_user)
    return if self == other_user
    active_relationships.find_or_create_by(followed_id: other_user.id)
  end

  # Unfollow a user
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id)&.destroy
  end

  # Check if following a user
  def following?(other_user)
    following.include?(other_user)
  end

  # Check if user liked a tweet
  def liked?(tweet)
    likes.exists?(tweet_id: tweet.id)
  end

  # Display name with fallback
  def name_display
    display_name.presence || "@#{username}"
  end

  # Feed - tweets from followed users and self
  def feed
    following_ids_subquery = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Tweet.where("user_id IN (#{following_ids_subquery}) OR user_id = :user_id", user_id: id)
         .includes(:user, :likes, :comments)
         .order(created_at: :desc)
  end

  # Following tweets - only from followed users
  def following_tweets
    following_ids_subquery = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Tweet.where("user_id IN (#{following_ids_subquery})", user_id: id)
         .includes(:user, :likes, :comments)
         .order(created_at: :desc)
  end
end

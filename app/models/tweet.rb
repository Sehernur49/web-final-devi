class Tweet < ApplicationRecord
  # === Associations ===
  belongs_to :user, counter_cache: true
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user

  # === Validations ===
  validates :content, presence: true, length: { maximum: 280 }

  # === Scopes ===
  scope :recent, -> { order(created_at: :desc) }
  scope :with_associations, -> { includes(:user, :likes, :comments) }

  # === Broadcasts ===
  # Turbo Streams - broadcast updates
  after_create_commit -> {
    broadcast_prepend_to "tweets",
      partial: "tweets/tweet",
      locals: { tweet: self },
      target: "tweets"
  }

  after_destroy_commit -> {
    broadcast_remove_to "tweets"
  }
end

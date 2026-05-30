class Comment < ApplicationRecord
  # === Associations ===
  belongs_to :user
  belongs_to :tweet, counter_cache: true

  # === Validations ===
  validates :content, presence: true, length: { maximum: 280 }

  # === Scopes ===
  scope :recent, -> { order(created_at: :desc) }
end

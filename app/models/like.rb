class Like < ApplicationRecord
  # === Associations ===
  belongs_to :user
  belongs_to :tweet, counter_cache: true

  # === Validations ===
  validates :user_id, uniqueness: { scope: :tweet_id, message: "bu tweet'i zaten beğendiniz" }
end

class Relationship < ApplicationRecord
  # === Associations ===
  belongs_to :follower, class_name: "User", counter_cache: :following_count
  belongs_to :followed, class_name: "User", counter_cache: :followers_count

  # === Validations ===
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validates :follower_id, uniqueness: { scope: :followed_id }

  # Cannot follow yourself
  validate :not_self_follow

  private

  def not_self_follow
    errors.add(:follower_id, "kendini takip edemezsin") if follower_id == followed_id
  end
end

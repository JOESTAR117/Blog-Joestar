class Article < ApplicationRecord
  validates :title, presence: true, length: { minimum: 3 }
  validates :body, presence: true, length: { minimum: 5 }

  paginates_per 5

  scope :desc_order, -> { order(created_at: :desc) }
  scope :without_highlights, ->(ids) { where("id NOT IN(#{ids})") }
end

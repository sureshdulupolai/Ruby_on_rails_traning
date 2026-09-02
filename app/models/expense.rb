class Expense < ApplicationRecord
  VALID_CATEGORIES = %w[Food Travel Shopping Bills Entertainment Other].freeze

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true, inclusion: { in: VALID_CATEGORIES }
  validates :date, presence: true
  validates :description, length: { maximum: 500 }, allow_blank: true
end

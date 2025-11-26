class Trip < ApplicationRecord
  belongs_to :user
  has_many :expenses, dependent: :destroy

  validates :country, presence: true

  # TODO: add a category for countries
  # TODO: add automatically the currency based on the country
  # TODO: budget to be adapted and optional based on the country
end

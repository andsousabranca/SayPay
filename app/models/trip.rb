class Trip < ApplicationRecord
  belongs_to :user
  has_many :expenses, dependent: :destroy

  monetize :budget_cents

  validates :country, presence: true

  # TODO: add a category for countries
  # TODO: add automatically the currency based on the country
  # TODO: budget to be adapted and optional based on the country

  def country_acronym(country)
    ISO3166::Country.find_country_by_any_name(country).alpha3
  end
end

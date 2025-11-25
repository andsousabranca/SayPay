class Expense < ApplicationRecord
  belongs_to :trip

  CATEGORIES = [
    "Meals",
    "Drinks & Nightlife",
    "Local Transport",
    "Flights & Long-haul Transport",
    "Car (rental/fuel/parking/tolls)",
    "Accommodation",
    "Activities & Tours",
    "Communication & Connectivity",
    "Travel Docs & Insurance",
    "Health & Safety",
    "Shopping & Supplies",
    "Fees & Banking",
    "Tips & Gratuities",
    "Other"
  ]

  VALID_CURRENCIES = Money::Currency.table.keys.map{ |k| k.to_s.upcase }

  validates :local_amount, presence: true, numericality: { greater_than: 0 }
  validates :base_amount, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  # validate that currency is a valid ISO currency code
  validates :local_currency, presence: true, inclusion: { in: VALID_CURRENCIES }
end

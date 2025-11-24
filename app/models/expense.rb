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

  validates :local_amount, presence: true, numericality: { greater_than: 0 }
  validates :base_amount, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  # TODO: update local_amount and base_amount categories with currency model


end

class Expense < ApplicationRecord
  belongs_to :trip

  has_one_attached :audio

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

  # set defaults when initializing
  attribute :local_amount, :integer, default: nil
  attribute :base_amount, :integer, default: nil
  attribute :category, :string, default: nil
  attribute :local_currency, :string, default: nil

  # allow nil values
  validates :local_amount, numericality: { greater_than: 0 }, allow_nil: true
  validates :base_amount, numericality: { greater_than: 0 }, allow_nil: true
  validates :category, inclusion: { in: CATEGORIES }, allow_blank: true

  # validate that currency is a valid ISO currency code
  validates :local_currency, inclusion: { in: VALID_CURRENCIES }, allow_blank: true

  # validate acceptable audio file types
  validate :acceptable_audio

  # TODO: check that audio file is maximum 1 min long

  private

  def acceptable_audio
    return unless audio.attached?

    unless audio.byte_size <= 5.megabytes
      errors.add(:audio, "is too big. Maximum size is 5MB.")
    end

    acceptable_types = %w[audio/webm audio/ogg audio/wav audio/mpeg audio/mp4]
    unless acceptable_types.include?(audio.content_type)
      errors.add(:audio, "must be an audio file (webm/ogg/wav/mp3)")
    end
  end
end

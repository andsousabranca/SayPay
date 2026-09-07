# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Expense.destroy_all
Message.destroy_all
Chat.destroy_all
Trip.destroy_all
User.destroy_all

user = User.create!(email: "test@test.de", password: "123123", first_name: "Pierre", base_currency: "EUR")

Trip.create!(
  country: "Laos",
  budget: 400,
  user_id: user.id,
  url: "https://images.unsplash.com/photo-1441632260885-881646a7fd4d?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  start_date: Date.new(2025, 10, 28),
  end_date: Date.new(2025, 11, 5)
)

first_trip = Trip.create!(
  country: "Thailand",
  budget: 900,
  user_id: user.id,
  url: "https://images.unsplash.com/photo-1519451241324-20b4ea2c4220?ixid=M3w4Mzc4NzN8MHwxfHNlYXJjaHwxfHx0aGFpbGFuZHxlbnwwfHx8fDE3NjQ3MzAwNjh8MA&ixlib=rb-4.1.0&utm_source=SayPay&utm_medium=referral&utm_campaign=api-credit",
  start_date: Date.new(2025, 11, 6),
  end_date: Date.new(2025, 11, 14)
)

Expense.create!(category: "Shopping & Supplies", local_amount_cents: 1870100, local_amount_currency: "THB", base_amount_cents: 50000, base_amount_currency: user.base_currency, audio_transcript: "designer t-shirt", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 14961, local_amount_currency: "THB", base_amount_cents: 400, base_amount_currency: user.base_currency, audio_transcript: "dinner", notes: "none", trip_id: first_trip.id)


# Chat.create!(user_id: user.id, title: "test")

puts "User count: #{User.count}"
puts "Trip count: #{Trip.count}"
puts "Expense count: #{Expense.count}"
puts "Chat count: #{Chat.count}"
puts "Message count: #{Message.count}"

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

user = User.create!(email: "test@test.de", password: "123123", first_name: "Test", base_currency: "USD")

first_trip = Trip.create!(
  country: "Thailand",
  budget: 400.0,
  user_id: user.id,
  url: "",
  start_date: Date.new(2025, 12, 28),
  end_date: Date.new(2026, 01, 14)
)

last_trip = Trip.create!(
  country: "Indonesia",
  budget: 300.0,
  user_id: user.id,
  url: "",
  start_date: Date.new(2025, 12, 14),
  end_date: Date.new(2025, 12, 28)
)

Expense.create!(category: "Meals", local_amount_cents: 200000, local_amount_currency: "IDR", base_amount_cents: 1000, base_amount_currency: "EUR", audio_transcript: "burger for 200k rupiah", notes: "none", trip_id: last_trip.id)
Expense.create!(category: "Shopping & Supplies", local_amount_cents: 300000, local_amount_currency: "IDR", base_amount_cents: 1500, base_amount_currency: "EUR", audio_transcript: "shirt for 300k rupiah", notes: "none", trip_id: last_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 56250, local_amount_currency: "IDR", base_amount_cents: 500, base_amount_currency: "EUR", audio_transcript: "coffee for 100k rupiah thai bath", notes: "none", trip_id: last_trip.id)

Expense.create!(category: "Health & Safety", local_amount_cents: 10000, local_amount_currency: "THB", base_amount_cents: 266, base_amount_currency: "EUR", audio_transcript: "paracetamol for 100 thai bath", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Meals", local_amount_cents: 60000, local_amount_currency: "THB", base_amount_cents: 1600, base_amount_currency: "EUR", audio_transcript: "dinner for 600 thab bath", notes: "none", trip_id: first_trip.id)
Expense.create!(category: "Activities & Tours", local_amount_cents: 100000, local_amount_currency: "THB", base_amount_cents: 2666, base_amount_currency: "EUR", audio_transcript: "Snorkeling for 1000 thai bath", notes: "none", trip_id: first_trip.id)

Chat.create!(user_id: user.id, title: "test")

puts "User count: #{User.count}"
puts "Trip count: #{Trip.count}"
puts "Expense count: #{Expense.count}"
puts "Chat count: #{Chat.count}"
puts "Message count: #{Message.count}"

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

last_trip = Trip.create!(user_id: user.id, country: "Germany", budget: 1000)

Expense.create!(category: "Meals", local_currency: "IDR", local_amount: 200000, base_amount: 10, audio_transcript: "burger for 200k rupiah", notes: "none", trip_id: last_trip.id)
Expense.create!(category: "Meals", local_currency: "IDR", local_amount: 300000, base_amount: 15, audio_transcript: "steak for 300k rupiah", notes: "none", trip_id: last_trip.id)

Chat.create!(user_id: user.id, title: "test")

puts "User count: #{User.count}"
puts "Trip count: #{Trip.count}"
puts "Expense count: #{Expense.count}"
puts "Chat count: #{Chat.count}"
puts "Message count: #{Message.count}"

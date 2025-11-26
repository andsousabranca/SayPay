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

Trip.create!(user_id: user.id, country: "Germany", budget: 1000)

puts "User count: #{User.count}"
puts "Trip count: #{Trip.count}"
puts "Expense count: #{Expense.count}"
puts "Chat count: #{Chat.count}"
puts "Message count: #{Message.count}"



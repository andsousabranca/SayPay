# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end



# puts "Destroying all Users"
# User.destroy_all

# puts "Creating test User"
# User.create(
#   email: "test@email.com",
#   first_name: "Test",
#   base_currency: "EUR",
#   password: "123123",
#   password_confirmation: "123123"
# )

puts "Destroying all Trips"
Trip.destroy_all

puts "Seeding Trips"
Trip.create(country: "Indonesia", budget: 300, user_id: 2)
Trip.create(country: "Japan", budget: 600, user_id: 2)

puts "Created #{Trip.count} Trips."

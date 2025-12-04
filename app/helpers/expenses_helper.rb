module ExpensesHelper

  def expense_icons(category)
    case category
      when "Meals"
        icon = "utensils"
      when "Drinks & Nightlife"
        icon = "martini"
      when "Local Transport"
        icon = "bus"
      when "Flights & Long-haul Transport"
        icon = "plane-takeoff"
      when "Car (rental/fuel/parking/tolls)"
        icon = "car"
      when "Accommodation"
        icon = "house"
      when "Activities & Tours"
        icon = "smile"
      when "Communication & Connectivity"
        icon = "phone"
      when "Travel Docs & Insurance"
        icon = "file-text"
      when "Health & Safety"
        icon = "heart-plus"
      when "Shopping & Supplies"
        icon = "shopping-cart"
      when "Fees & Banking"
        icon = "landmark"
      when "Tips & Gratuities"
        icon = "hand-coins"
      when "Other"
        icon = "shuffle"
    end
  end

end

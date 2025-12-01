class AddUrlToTrips < ActiveRecord::Migration[7.1]
  def change
    add_column :trips, :url, :string
  end
end

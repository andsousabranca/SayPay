class AddBaseCurrencyAndNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :base_currency, :string
  end
end

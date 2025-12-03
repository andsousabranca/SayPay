class ConvertBudgetToMoney < ActiveRecord::Migration[7.1]
  def change
    # 1. Rename float columns → temporary names
    rename_column :trips, :budget, :budget_float

    # 2. Add new integer columns for cents
    add_monetize :trips, :budget

    # 3. Remove the old float columns
    remove_column :trips, :budget_float, :float
  end
end


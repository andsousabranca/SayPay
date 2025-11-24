class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.string :category
      t.string :local_currency
      t.float :local_amount
      t.float :base_amount
      t.text :audio_transcript
      t.text :notes
      t.references :trip, null: false, foreign_key: true

      t.timestamps
    end
  end
end

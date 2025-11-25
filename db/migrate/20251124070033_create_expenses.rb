class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.string :category
      t.string :local_currency, limit: 3, null: false, default: "USD"
      t.integer :local_amount_cents, null: false, default: 0
      t.integer :base_amount_cents, null: false, default: 0
      t.text :audio_transcript
      t.text :notes
      t.references :trip, null: false, foreign_key: true

      t.timestamps
    end
  end
end

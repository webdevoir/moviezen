class CreateCredits < ActiveRecord::Migration[5.2]
  def change
    create_table :credits do |t|
      t.integer :cast_id
      t.string :credit_id
      t.string :character
      t.integer :order
      t.string :department
      t.string :job

      t.references :person, foreign_key: true
      t.references :movie, foreign_key: true

      t.timestamps
    end
  end
end

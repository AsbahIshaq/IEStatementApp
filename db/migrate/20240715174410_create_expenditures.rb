class CreateExpenditures < ActiveRecord::Migration[7.1]
  def change
    create_table :expenditures do |t|
      t.string :name
      t.decimal :amount
      t.references :ie_statement, null: false, foreign_key: true

      t.timestamps
    end
  end
end

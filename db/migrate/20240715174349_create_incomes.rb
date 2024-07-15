class CreateIncomes < ActiveRecord::Migration[7.1]
  def change
    create_table :incomes do |t|
      t.string :name
      t.decimal :amount
      t.references :ie_statement, null: false, foreign_key: true

      t.timestamps
    end
  end
end

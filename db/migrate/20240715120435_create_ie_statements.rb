class CreateIeStatements < ActiveRecord::Migration[7.1]
  def change
    create_table :ie_statements do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_income, default: 0, null: false
      t.decimal :total_expenditure, default: 0, null: false
      t.decimal :disposable_income, default: 0, null: false
      t.string :rating
      t.string :month

      t.timestamps
    end
  end
end

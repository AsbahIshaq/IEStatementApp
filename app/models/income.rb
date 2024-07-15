class Income < ApplicationRecord
  belongs_to :ie_statement
  validates :name, :amount, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_commit :recommit_ie_statement

  def recommit_ie_statement
  	ie_statement.save if ie_statement.persisted?
  end
end

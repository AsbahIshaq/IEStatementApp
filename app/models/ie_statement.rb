class IeStatement < ApplicationRecord
  belongs_to :user
  before_save :calculate_total_income, :calculate_total_expenditure, :calculate_disposable_income, :calculate_rating
  has_many :incomes, dependent: :destroy
  has_many :expenditures, dependent: :destroy

  VALID_MONTH_NAMES = Date::MONTHNAMES.compact.map(&:downcase)

  validates :month, presence: true, inclusion: { in: VALID_MONTH_NAMES, message: 'must be a valid month name in lowercase' }

  def calculate_disposable_income
    self.disposable_income = total_income - total_expenditure
  end

  def calculate_rating
    return self.rating = 'D' if disposable_income <= 0 || total_income == 0

    ratio = total_expenditure / total_income
    self.rating = case ratio
                  when 0...0.1 then 'A'
                  when 0.1...0.3 then 'B'
                  when 0.3...0.5 then 'C'
                  else 'D'
                  end
  end

  def calculate_total_income
    self.total_income = self.incomes.pluck(:amount).sum
  end

  def calculate_total_expenditure
    self.total_expenditure = self.expenditures.pluck(:amount).sum
  end

  def add_incomes(incomes_list)
    ActiveRecord::Base.transaction do
      incomes_list.each do |income|
        self.incomes.create!(name: income['name'], amount: income['amount'])
      end
      save!
    end
  end

  def add_expenditures(expenditures_list)
    ActiveRecord::Base.transaction do
      expenditures_list.each do |expenditure|
        self.expenditures.create!(name: expenditure['name'], amount: expenditure['amount'])
      end
      save!
    end
  end
end

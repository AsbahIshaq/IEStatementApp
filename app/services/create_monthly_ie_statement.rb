class CreateMonthlyIeStatement
  attr_accessor :user, :month, :income, :expenditure, :ie_statement

  def initialize(user, month, income, expenditure)
    @user = user
    @month = month
    @income = income
    @expenditure = expenditure
  end

  def self.call(user, month, income, expenditure)
    new(user, month, income, expenditure).call
  end

  def call
    ActiveRecord::Base.transaction do
      @ie_statement = @user.ie_statements.find_or_create_by(month: @month)

      @ie_statement.add_incomes(@income)
      @ie_statement.add_expenditures(@expenditure)
      @ie_statement.calculate_disposable_income
      @ie_statement.calculate_rating

      @ie_statement.save!
    end
    @ie_statement
  end
end

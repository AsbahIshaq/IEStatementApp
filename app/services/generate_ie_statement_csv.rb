class GenerateIeStatementCsv
  attr_accessor :user, :month

  def initialize(user, month)
    @user = user
    @month = month
  end

  def self.call(user, month)
    new(user, month).call
  end

  def call
    ie_statement = IeStatement.find_by(user: @user, month: @month)
    convert_statement_to_csv(ie_statement) if ie_statement
  end

  private

  def convert_statement_to_csv(ie_statement)
    CSV.generate(headers: true) do |csv|
      csv << ['Income', 'Amount', 'Expenditure', 'Amount']

      incomes = ie_statement.incomes.to_a
      expenditures = ie_statement.expenditures.to_a

      total_rows = [incomes.count, expenditures.count].max
      total_rows.times do |index|
        income = incomes[index] || {}
        expenditure = expenditures[index] || {}

        csv << [income['name'], income['amount'], expenditure['name'], expenditure['amount']]
      end
    end
  end
end

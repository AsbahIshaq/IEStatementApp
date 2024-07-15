class IeStatementsController < ApplicationController
  include ActionController::MimeResponds
  before_action :set_user, :validate_user

  def create
    @ie_statement = CreateMonthlyIeStatement.call(@user, ie_statement_params[:month], ie_statement_params[:income], ie_statement_params[:expenditure])
    if @ie_statement.persisted?
      render json: @ie_statement, status: :created
    else
      render json: @ie_statement.errors, status: :unprocessable_entity
    end
  end

  def index
    @ie_statements = @user.ie_statements
    render json: @ie_statements
  end

  def show
    @ie_statement = @user.ie_statements.find(params[:id])
    render json: @ie_statement
  end

  def monthly_statement
    @ie_statement = @user.ie_statements.includes(:incomes, :expenditures).find_by(month: params[:month])
    render json: @ie_statement, include: [:incomes, :expenditures]
  end

  def monthly_statement_download
    month = params[:month]
    ie_statement_csv = GenerateIeStatementCsv.call(@user, month)

    respond_to do |format|
      format.csv { send_data ie_statement_csv, filename: "ie_statement_#{month}.csv" }
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def validate_user
    unless @current_user == @user
      render json: { error: 'You are not authorized for this action' }, status: :unauthorized
    end
  end

  def ie_statement_params
    params.require(:ie_statement).permit(
      :month,
      income: [:name, :amount],
      expenditure: [:name, :amount]
    )
  end
end

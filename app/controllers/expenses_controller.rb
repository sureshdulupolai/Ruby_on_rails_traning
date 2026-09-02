class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[show edit update destroy]

  # GET /expenses
  def index
    @expenses = Expense.order(date: :desc)
  end

  # GET /expenses/:id
  def show
  end

  # GET /expenses/new
  def new
    @expense = Expense.new(date: Date.today)
  end

  # POST /expenses
  def create
    @expense = Expense.new(expense_params)
    if @expense.save
      redirect_to @expense, notice: "Expense was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /expenses/:id/edit
  def edit
  end

  # PATCH /expenses/:id
  def update
    if @expense.update(expense_params)
      redirect_to @expense, notice: "Expense was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /expenses/:id
  def destroy
    @expense.destroy
    redirect_to expenses_url, notice: "Expense was successfully deleted."
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:amount, :category, :date, :description)
  end
end

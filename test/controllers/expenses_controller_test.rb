require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @expense = expenses(:one)
  end

  # Index action tests
  test "should get index" do
    get expenses_url
    assert_response :success
    assert_select "h1", text: "Expenses"
  end

  test "index displays empty state message when no expenses" do
    Expense.delete_all
    
    get expenses_url
    assert_response :success
    assert_match /No expenses recorded yet/, response.body
    assert_match /Add your first expense/, response.body
  end

  test "expenses should be ordered newest first" do
    # Delete existing fixtures to have a clean test
    Expense.delete_all
    
    older_expense = Expense.create!(
      amount: 100,
      category: "Food",
      date: 3.days.ago.to_date
    )
    newer_expense = Expense.create!(
      amount: 200,
      category: "Travel",
      date: Date.today
    )

    get expenses_url
    assert_response :success
    
    # Get the expense records from the view
    expenses = assigns(:expenses)
    assert_equal newer_expense, expenses.first
    assert_equal older_expense, expenses.last
  end

  test "index displays existing expenses" do
    get expenses_url
    assert_response :success
    # Verify that expenses are in the response body
    assert_match @expense.category, response.body
    assert_match @expense.amount.to_s, response.body
  end

  # Show action tests
  test "should get show" do
    get expense_url(@expense)
    assert_response :success
  end

  test "show displays expense details" do
    expense = Expense.create!(
      amount: 250,
      category: "Food",
      date: Date.today,
      description: "Lunch at restaurant"
    )
    
    get expense_url(expense)
    assert_response :success
    # Check for currency symbol and amount in the response body
    assert_match /₹/, response.body
    assert_match /Food/, response.body
    assert_match /250/, response.body
    assert_match /Lunch at restaurant/, response.body
  end

  # New action tests
  test "should get new" do
    get new_expense_url
    assert_response :success
  end

  test "new expense should have today's date as default" do
    get new_expense_url
    assert_response :success
    expense = assigns(:expense)
    assert_equal Date.today, expense.date
  end

  # Create action tests
  test "should create expense with valid data" do
    assert_difference("Expense.count") do
      post expenses_url, params: {
        expense: {
          amount: 250,
          category: "Food",
          date: Date.today,
          description: "Lunch"
        }
      }
    end
    assert_redirected_to expense_url(Expense.last)
    assert_equal "Expense was successfully created.", flash[:notice]
  end

  test "should create expense without description" do
    assert_difference("Expense.count") do
      post expenses_url, params: {
        expense: {
          amount: 150,
          category: "Travel",
          date: Date.today
        }
      }
    end
    assert_redirected_to expense_url(Expense.last)
  end

  test "should not create expense with invalid data" do
    assert_no_difference("Expense.count") do
      post expenses_url, params: {
        expense: {
          amount: -100,
          category: "Food",
          date: Date.today
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create expense with missing amount" do
    assert_no_difference("Expense.count") do
      post expenses_url, params: {
        expense: {
          category: "Food",
          date: Date.today
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create expense with invalid category" do
    assert_no_difference("Expense.count") do
      post expenses_url, params: {
        expense: {
          amount: 100,
          category: "InvalidCategory",
          date: Date.today
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create expense without date" do
    assert_no_difference("Expense.count") do
      post expenses_url, params: {
        expense: {
          amount: 100,
          category: "Food"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create expense with description exceeding 500 characters" do
    long_description = "a" * 501
    assert_no_difference("Expense.count") do
      post expenses_url, params: {
        expense: {
          amount: 100,
          category: "Food",
          date: Date.today,
          description: long_description
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "create displays validation errors when submission fails" do
    post expenses_url, params: {
      expense: {
        amount: -100,
        category: "Food",
        date: Date.today
      }
    }
    assert_response :unprocessable_entity
    assert_match /error/, response.body.downcase
    assert_match /greater than/, response.body.downcase
  end

  test "create should preserve submitted values on validation failure" do
    post expenses_url, params: {
      expense: {
        amount: -100,
        category: "Food",
        date: Date.today,
        description: "Test"
      }
    }
    
    expense = assigns(:expense)
    assert_equal -100, expense.amount
    assert_equal "Food", expense.category
    assert_equal "Test", expense.description
  end

  # Edit action tests
  test "should get edit" do
    get edit_expense_url(@expense)
    assert_response :success
  end

  test "edit should display existing expense data" do
    expense = Expense.create!(
      amount: 300,
      category: "Shopping",
      date: Date.today,
      description: "Groceries"
    )
    
    get edit_expense_url(expense)
    assert_response :success
    assert_select "h1", text: "Edit Expense"
  end

  # Update action tests
  test "should update expense with valid data" do
    patch expense_url(@expense), params: {
      expense: {
        amount: 500,
        category: "Bills",
        date: 1.day.ago.to_date,
        description: "Updated"
      }
    }
    assert_redirected_to expense_url(@expense)
    assert_equal "Expense was successfully updated.", flash[:notice]
    
    @expense.reload
    assert_equal 500, @expense.amount
    assert_equal "Bills", @expense.category
  end

  test "should not update expense with invalid data" do
    original_amount = @expense.amount
    patch expense_url(@expense), params: {
      expense: {
        amount: -100,
        category: "Food"
      }
    }
    assert_response :unprocessable_entity
    
    @expense.reload
    assert_equal original_amount, @expense.amount
  end

  test "update should preserve submitted values on validation failure" do
    patch expense_url(@expense), params: {
      expense: {
        amount: -50,
        category: "Travel",
        date: Date.today,
        description: "Test update"
      }
    }
    
    expense = assigns(:expense)
    assert_equal -50, expense.amount
    assert_equal "Travel", expense.category
    assert_equal "Test update", expense.description
  end

  # Destroy action tests
  test "should destroy expense" do
    expense = Expense.create!(
      amount: 100,
      category: "Food",
      date: Date.today
    )
    
    assert_difference("Expense.count", -1) do
      delete expense_url(expense)
    end
    assert_redirected_to expenses_url
    assert_equal "Expense was successfully deleted.", flash[:notice]
  end
end

require "test_helper"

class ExpenseTest < ActiveSupport::TestCase
  # Amount validation tests
  test "amount is required" do
    expense = Expense.new(category: "Food", date: Date.today, description: "Lunch")
    assert_not expense.valid?
    assert_includes expense.errors[:amount], "can't be blank"
  end

  test "amount must be greater than zero" do
    expense = Expense.new(amount: 0, category: "Food", date: Date.today)
    assert_not expense.valid?
    assert_includes expense.errors[:amount], "must be greater than 0"
  end

  test "amount must be positive" do
    expense = Expense.new(amount: -100, category: "Food", date: Date.today)
    assert_not expense.valid?
    assert_includes expense.errors[:amount], "must be greater than 0"
  end

  test "amount must be numeric" do
    expense = Expense.new(amount: "not a number", category: "Food", date: Date.today)
    assert_not expense.valid?
    assert_includes expense.errors[:amount], "is not a number"
  end

  # Category validation tests
  test "category is required" do
    expense = Expense.new(amount: 100, date: Date.today)
    assert_not expense.valid?
    assert_includes expense.errors[:category], "can't be blank"
  end

  test "category must be one of valid categories" do
    expense = Expense.new(amount: 100, category: "InvalidCategory", date: Date.today)
    assert_not expense.valid?
    assert_includes expense.errors[:category], "is not included in the list"
  end

  test "accepts all valid categories" do
    valid_categories = %w[Food Travel Shopping Bills Entertainment Other]
    valid_categories.each do |category|
      expense = Expense.new(amount: 100, category: category, date: Date.today)
      assert expense.valid?, "Should accept category: #{category}"
    end
  end

  # Explicit test for each category per TASK-007 requirement
  test "accepts Food category" do
    expense = Expense.new(amount: 100, category: "Food", date: Date.today)
    assert expense.valid?, "Should accept Food category"
  end

  test "accepts Travel category" do
    expense = Expense.new(amount: 100, category: "Travel", date: Date.today)
    assert expense.valid?, "Should accept Travel category"
  end

  test "accepts Shopping category" do
    expense = Expense.new(amount: 100, category: "Shopping", date: Date.today)
    assert expense.valid?, "Should accept Shopping category"
  end

  test "accepts Bills category" do
    expense = Expense.new(amount: 100, category: "Bills", date: Date.today)
    assert expense.valid?, "Should accept Bills category"
  end

  test "accepts Entertainment category" do
    expense = Expense.new(amount: 100, category: "Entertainment", date: Date.today)
    assert expense.valid?, "Should accept Entertainment category"
  end

  test "accepts Other category" do
    expense = Expense.new(amount: 100, category: "Other", date: Date.today)
    assert expense.valid?, "Should accept Other category"
  end

  # Date validation tests
  test "date is required" do
    expense = Expense.new(amount: 100, category: "Food")
    assert_not expense.valid?
    assert_includes expense.errors[:date], "can't be blank"
  end

  # Description validation tests
  test "description is optional" do
    expense = Expense.new(amount: 100, category: "Food", date: Date.today)
    assert expense.valid?, "Description should be optional"
  end

  test "description can be empty string" do
    expense = Expense.new(amount: 100, category: "Food", date: Date.today, description: "")
    assert expense.valid?, "Empty description should be valid"
  end

  test "description with 500 characters is valid" do
    description = "a" * 500
    expense = Expense.new(amount: 100, category: "Food", date: Date.today, description: description)
    assert expense.valid?, "Description with exactly 500 characters should be valid"
  end

  test "description exceeding 500 characters is invalid" do
    description = "a" * 501
    expense = Expense.new(amount: 100, category: "Food", date: Date.today, description: description)
    assert_not expense.valid?
    assert_includes expense.errors[:description], "is too long (maximum is 500 characters)"
  end

  # Valid expense test
  test "valid expense can be saved" do
    expense = Expense.new(
      amount: 250,
      category: "Food",
      date: Date.today,
      description: "Lunch at restaurant"
    )
    assert expense.valid?, "Valid expense should pass validation"
    assert expense.save, "Valid expense should be saved"
  end

  test "valid expense without description can be saved" do
    expense = Expense.new(
      amount: 150,
      category: "Travel",
      date: Date.today
    )
    assert expense.valid?, "Valid expense without description should pass validation"
    assert expense.save, "Valid expense without description should be saved"
  end

  test "decimal amounts are accepted" do
    expense = Expense.new(amount: 99.99, category: "Food", date: Date.today)
    assert expense.valid?, "Decimal amounts should be valid"
    assert expense.save, "Decimal amounts should be saved"
  end

  # Additional explicit tests per TASK-007 requirements

  test "expense with positive amount is valid" do
    expense = Expense.new(amount: 100, category: "Food", date: Date.today)
    assert expense.valid?, "Positive amount should be valid"
  end

  test "expense with valid date is valid" do
    expense = Expense.new(amount: 100, category: "Food", date: Date.today)
    assert expense.valid?, "Expense with valid date should be valid"
  end
end

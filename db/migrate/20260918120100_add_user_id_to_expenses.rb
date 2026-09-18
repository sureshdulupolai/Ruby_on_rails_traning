# frozen_string_literal: true

class AddUserIdToExpenses < ActiveRecord::Migration[8.1]
  def change
    add_reference :expenses, :user, foreign_key: true
  end
end

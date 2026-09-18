class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :expenses, dependent: :destroy

  # Helper method to display name or email fallback
  def display_name
    email.split('@').first.capitalize
  end
  
end

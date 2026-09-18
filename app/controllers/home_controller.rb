class HomeController < ApplicationController
  # Allow non-logged-in visitors to view the landing page
  skip_before_action :authenticate_user!, only: [:index]

  def index
    # If already logged in, redirect straight to expenses dashboard
    redirect_to expenses_path if user_signed_in?
  end
end

class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :display_not_authorized

  private

  def display_not_authorized
    flash[:alert] = 'You are not authorized to do that'
    if current_user
      redirect_to(request.referrer || root_path)
    else
      redirect_to new_user_session_path
    end
  end



  class Amount
    @default = 1500
    class << self
      attr_accessor :default
    end
  end



  PREMIUM_PLAN = Stripe::Plan.create(
    name: 'Premium Plan',
    id: 'premium-yearly',
    interval: 'year',
    currency: 'usd',
    amount: Amount.default
  )
end

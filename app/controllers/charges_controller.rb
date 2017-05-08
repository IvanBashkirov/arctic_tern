class ChargesController < ApplicationController
  before_action :authorize_charge

  def create_upgrade
    # Creates a Stripe Customer object, for associating
    # with the charge
    customer = Stripe::Customer.retrieve(current_user.customer_id)
    customer.source = params[:stripeToken]
    customer.save
    subscription = customer.subscriptions.first
    subscription.plan = "premium-yearly"
    subscription.save

    flash[:notice] = "Thanks for all the money, #{current_user.email}! Feel free to pay me again."
    current_user.premium!
    redirect_to root_path # or wherever

    # Stripe will send back CardErrors, with friendly messages
    # when something goes wrong.
    # This `rescue block` catches and displays those errors.
  rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_upgrade_path
    end

  def new_upgrade
    @stripe_btn_data = {
      key: Rails.configuration.stripe[:publishable_key].to_s,
      description: "BigMoney Membership - #{current_user.email}",
      amount: Stripe::Plan.retrieve("premium-yearly").amount
    }
  end

  private

  def authorize_charge
    display_not_authorized unless current_user.present?
  end
end

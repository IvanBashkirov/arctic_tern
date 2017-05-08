class ChargesController < ApplicationController
  before_action :authorize_charge

  def switch_to_premium

    if current_user.premium?
      flash[:alert] = "You are already on a premium plan"
      redirect_to change_subscription_path
    end

    customer = Stripe::Customer.retrieve(current_user.customer_id)
    customer.source = params[:stripeToken]
    customer.save
    subscription = customer.subscriptions.first
    subscription.plan = "premium-yearly"
    subscription.save

    flash[:notice] = 'You succesfully upgraded your plan to "Premium"'
    current_user.premium!
    redirect_to root_path # or wherever

  rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to change_subscription_path
    end


  def switch_to_basic

    if current_user.basic?
      flash[:alert] = "You are already on a basic plan"
      redirect_to change_subscription_path
    end
    customer = Stripe::Customer.retrieve(current_user.customer_id)
    customer.sources.each{|card| card.delete} # delete all cards
    customer.save
    subscription = customer.subscriptions.first
    subscription.plan = "basic-yearly"
    subscription.save

    flash[:notice] = 'You succesfully downgraded your plan to "Basic"'
    current_user.basic!
    redirect_to root_path # or wherever

    end

  def change_subscription
    @stripe_btn_data = {
      key: Rails.configuration.stripe[:publishable_key].to_s,
      description: "BigMoney Membership - #{current_user.email}",
      amount: Stripe::Plan.retrieve("premium-yearly").amount
    }
  end

  private

  def authorize_charge
    display_not_authorized unless user_signed_in?
  end
end

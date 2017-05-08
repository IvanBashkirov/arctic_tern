class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_many :wikis
  before_create :assign_role

  def assign_role
    self.role ||= :basic
  end

  enum role: [:basic, :premium, :admin]
  private

  def subscribe_to_basic_plan
    customer = Stripe::Customer.create(
      email: self.email
    )
    self.customer_id = customer.id
    Stripe::Subscription.create(
      customer: customer.id,
      plan: "basic-yearly"
    )
    self.save!
  end

## Devise calls this after confirmation
  def after_confirmation
    subscribe_to_basic_plan
  end


end

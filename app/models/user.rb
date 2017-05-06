class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_many :wikis
  after_initialize :assign_role, :subscribe_to_basic_plan

  def assign_role
    self.role ||= :member
  end

  enum role: [:member, :premium, :admin]

  private

  def subscribe_to_basic_plan
    customer = Stripe::Customer.create(
      email: current_user.email
    )
    current_user.customer_id = customer.id
    Stripe::Subscription.create(
      customer: customer.id,
      plan => BASIC_PLAN.id
    )
  end

  BASIC_PLAN = Stripe::Plan.create(
    name: 'Basic Plan',
    id: 'basic-yearly',
    interval: 'year',
    currency: 'usd',
    amount: 0
  )
end

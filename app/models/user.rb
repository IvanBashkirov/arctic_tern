class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_many :wikis
  after_create :assign_role, :subscribe_to_basic_plan

  def assign_role
    self.role ||= :basic
    self.save
  end

  enum role: [:basic, :premium, :admin]
  private

  def subscribe_to_basic_plan
    puts "email"
    puts self.email
    customer = Stripe::Customer.create(
      email: self.email
    )
    puts "customer"
    puts customer
    self.customer_id = customer.id
    self.save
    puts "self customer_id"
    puts self.customer_id
    Stripe::Subscription.create(
      customer: customer.id,
      plan: "basic-yearly"
    )
  end


end

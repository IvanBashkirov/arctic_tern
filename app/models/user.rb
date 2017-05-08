class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_many :wikis
  before_create :assign_role



  enum role: [:basic, :premium, :admin]
  private

  def assign_role
    self.role ||= :basic
  end





end

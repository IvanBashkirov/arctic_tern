class Wiki < ApplicationRecord
  belongs_to :user

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :user, presence: true

  default_scope { order('updated_at DESC') } 
  scope :visible_to, -> (user) {(user && (user.premium? || user.admin?)) ? all : where(private: false) }

  after_initialize :fill_in_private_field

  def fill_in_private_field
    self.private = false if self.private.nil?
  end
end

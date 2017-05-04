class WikiPolicy < ApplicationPolicy
  def update?
    user.present?
  end
end

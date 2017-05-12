class WikiPolicy < ApplicationPolicy
  def update?
    user.present? && (user.admin? || (record.user == user) || record.collaborators.include?(user))
  end

  def show?
    if record.private?
      user.present? && ((wiki.user == user) || wiki.collaborators.include?(user) || user.admin?)
    else
      true
    end
  end

  def edit?
    update?
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def destroy?
    user.present? && (user.admin? || (record.user == user))
  end

  def index?
    true
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      wikis = []
      if user.admin?
        scope.all # if the user is an admin, show them all the wikis
      elsif user.premium?
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if !wiki.private || wiki.user == user || wiki.collaborators.include?(user)
            wikis << wiki # if the user is premium, only show them public wikis, or that private wikis they created, or private wikis they are a collaborator on
          end
        end
      else # this is the standard user
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if !wiki.private? || wiki.collaborators.include?(user)
            wikis << wiki # only show standard users public wikis and private wikis they are a collaborator on
          end
        end
      end
      Wiki.where(id: wikis.map(&:id))
    end
 end
end

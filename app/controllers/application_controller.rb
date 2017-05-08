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



end

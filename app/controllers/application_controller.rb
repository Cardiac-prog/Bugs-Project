class ApplicationController < ActionController::Base
  before_action :authenticate_user!            # this ensures user is login i.e. devise
  include Pagy::Backend             # Pagy::Backend allows you to use its pagination methods in your controllers.

  # Cancan     global exception handler
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to root_path
  end

  def after_sign_in_path_for(resource)
    projects_path # Redirect to the dashboard after sign-in
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path # Redirect to the homepage after sign-out
  end

  allow_browser versions: :modern
end

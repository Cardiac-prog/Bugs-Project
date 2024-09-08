class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    projects_path # Redirect to the dashboard after sign-in
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path # Redirect to the homepage after sign-out
  end

  allow_browser versions: :modern
end

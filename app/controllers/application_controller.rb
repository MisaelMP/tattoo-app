class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :current_user

  def current_user
    return nil unless session[:user_id].present?
    @current_user ||= User.find_by(id: session[:user_id])
    @current_user
  rescue => e
    Rails.logger.error "Error in current_user: #{e.message}"
    session[:user_id] = nil
    nil
  end
  helper_method :current_user

  def authorize
    unless current_user
      flash[:error] = "Please log in first"
      redirect_to '/login'
    end
  end


end

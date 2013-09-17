class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  before_filter :set_locale
  
  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    end
  end

end

class SetLanguageController < ApplicationController
  def english
    I18n.locale = :en
    set_session_and_redirect
  end

  def thai
    I18n.locale = :th
    set_session_and_redirect
  end

  def zh_tw
    I18n.locale = :zh_tw
    set_session_and_redirect
  end

  def zh_cn
    I18n.locale = :zh_cn
    set_session_and_redirect
  end
  
  private
  def set_session_and_redirect
    session[:locale] = I18n.locale
    redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to :root
  end
end

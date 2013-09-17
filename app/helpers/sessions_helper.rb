module SessionsHelper
  def sign_in(user)
    current_user = user
  end

  def signed_in?
    !session[:user_id].nil?
  end

  def sign_out
    current_user = nil
    cookies.delete(:remember_token)
  end
  
end

class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    
    session['fb_auth'] = auth
    session['fb_access_token'] = auth['credentials']['token']
    session['fb_error'] = nil
    user = User.where(:provider => auth['provider'],
    :fbid => auth['uid']).first || User.create_with_omniauth(auth, session['fb_access_token'])

    sign_in(user)
    session[:user_id] = user.id
    graph = Koala::Facebook::GraphAPI.new(session['fb_access_token']) # Note that session is used here
    @fbprofile = graph.get_object('me')
    user.gender=@fbprofile['gender']
    user.friend_list = nil
    user.save
    
    redirect_to user_path(id: session[:user_id])
  end

  def new
    redirect_to '/auth/facebook'
  end

  def destroy
    reset_session
    redirect_to root_url, notice => 'Signed out'
  end

end

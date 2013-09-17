class UsersController < ApplicationController
  require 'json'
  
  #get the gender of a user
  def getGender
    @user = User.find(params[:id])
    render :json => @user.getGender(params[:id])
  end

  #show the homepage of a user
  def show
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  #the method to show the homepage of a user
  def account
    @user = User.find(session[:user_id])
    
    respond_to do |format|
      format.html # account.html.erb
      format.json { render json: @user }
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.gender_pref.nil?
      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html { redirect_to user_path(id: session[:user_id], locale: session[:locale]), notice: 'User was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
      format.html { redirect_to user_path(id: session[:user_id], locale: session[:locale]), notice: 'Sorry, you can\'t change your gender preference more than once.' }
      format.json { head :no_content }
      end
    end

    @user.friend_list = nil
    @user.save
  end
  
  #show all the friends of a user
  def showFriendsList
    @user=User.find(session[:user_id])
    
    render :json => @user.showFriends(session,@user.id)
  end

  #show all the friends of a user
  def showFriendsKeys
    @user=User.find(session[:user_id])
    
    render :json => @user.showFriendsKeys(session, params[:key])
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  #Filter the friends based on the list of the conditions
  def filterFriends
    @user = User.find(session[:user_id])
    render :json => @user.filterFriends(session, params[:filter_conditions])
  end
end

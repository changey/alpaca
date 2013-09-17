class FavoritesController < ApplicationController
  # Lists all favorited profiles of the current user
  def index
    @favorites = current_user.favorites.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @favorites }
    end
  end

  # Favorite a profile
  def create
    @profile = Profile.find(params[:profile_id])
    # If the user has not favorited the profile, create the favorite record
    if current_user.favorites.where(:profile_id=>@profile.id).empty?
    @favorite = current_user.favorites.new
    @profile.favorites << @favorite
    @favorite.save

    render :text =>"Remove from My Favorites"
    # If the favorite exists, destroy the record
    else
      redirect_to :action=>"destroy" , :profile_id=>params[:profile_id]
      return
    end
  end

  # "Unfavorite" a profile
  def destroy
    @favorite = Favorite.where(:user_id =>session[:user_id], :profile_id=>params[:profile_id]).first
    @favorite.destroy
    render :text=>"Add to My Favorites!"
  end
end

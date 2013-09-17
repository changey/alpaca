class RatingsController < ApplicationController
  def create
    @profile = Profile.find(params[:profile_id])
    @rating = @profile.ratings.new(:user_id => session[:user_id], :rate => params[:rate], :category => params[:categ])
    @rating.save
    @profile.add_rating(@rating.category, @rating.rate)
    render json: @rating.profile.getRating(session, params[:categ])
  end

  def update
    @profile = Profile.find(params[:profile_id])
    @rating = @profile.ratings.where(:user_id => session[:user_id], :category => params[:categ])[0]
    if @rating
      @profile.update_rating(@rating.category, @rating.rate, params[:rate].to_f)
      @rating.update_attribute(:rate, params[:rate])
    end
    render json: @rating.profile.getRating(session, params[:categ])
  end

  def destroy
    @profile = Profile.find(params[:profile_id])
    @rating = Rating.where(:user_id => session[:user_id], :category => params[:categ])[0]
    if @rating
      @profile.delete_rating(@rating.category, @rating.rate)
      @rating.destroy
    end
    render json: @rating.profile.getRating(session, params[:categ])
  end
end

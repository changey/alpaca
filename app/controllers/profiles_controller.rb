class ProfilesController < ApplicationController
  before_filter :check_authorization

  #the method used to check the Facebook authorization of users. 
  #The user needs to give us authorization through our Facebook app so we can use users' information
  def check_authorization
    if params[:fbid]
      fbid = params[:fbid]
    elsif params[:profile] and params[:profile][:fbid]
      fbid = params[:profile][:fbid]
    else
      fbid = Profile.find(params[:id]).fbid
    end
    if !Profile.authorized(session, fbid)
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'Do not have permission.' }
        format.json { head :no_content }
      end
    end
  end

  #Show individual profile
  def show_profile
    profiles = Profile.where(:fbid => params[:fbid])
    if profiles.empty?
      @profile = Profile.new(fbid:params[:fbid])
      @profile.save
    else
      @profile = profiles[0]
    end
    @comments = @profile.comments
    @fb_object = @profile.get_fbobject(session)
    render 'show'
  end

  #Show all the profiles
  def show
    @profile = Profile.find(params[:id])
    @comments = @profile.comments
    @fb_object = @profile.get_fbobject(session)

    respond_to do |format|
      format.html
      format.json { render json: @fb_object }
    end
  end

  #Create the new profile
  def new
    @id=params[:fbid]
    @profile = Profile.find(:all, :conditions => ["fbid = ?",@id])

    if @profile.empty?
      @profile = Profile.new(fbid:@id)
      respond_to do |format|
        format.html
        format.json { render json: @profile }
      end
    else
      @profile = @profile[0]
      @fb_object = @profile.get_fbobject(session)
      @comments = @profile.comments
      respond_to do |format|
        format.html{render action: "show"}
        format.json { render json: @fb_object }
      end
    end
  end

  def create
    @fbid=params[:profile][:fbid]
    @profile = Profile.new(fbid:@fbid)
    @profile.save

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render json: @profile, status: :created, location: @profile }
      else
        format.html { render action: "new" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # get ratings related to this profile and logged in user
  def getRatings
    @profile = Profile.find(params[:id])
    render json: @profile.getRatings(session)
  end
end

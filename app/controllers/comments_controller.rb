class CommentsController < ApplicationController

  # Create comment on a profile
  def create
    @profile = Profile.find(params[:profile_id])
    @comment = @profile.comments.new(:body => params[:body], :user_id=>current_user.id )

      if @comment.save
        # return the comment and the user's anonymized facebook id
        render json: {:comment=>@comment, :uid=>@comment.anonymous_id}
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    end
  end


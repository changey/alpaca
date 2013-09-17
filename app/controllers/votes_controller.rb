class VotesController < ApplicationController
  # Create a vote on a comment
  def create
    # If user has not voted on the comment, created a new vote
    if current_user.votes.where(:comment_id=>params[:comment_id] ).empty?
    @vote = current_user.votes.new(:up=>params[:up])
    @comment = Comment.find(params[:comment_id])
    @comment.votes << @vote

    if @vote.save
      # Return vote count
      render json: Vote.where(:up=> params[:up], :comment_id => params[:comment_id]).size, status: :created, location: @vote
    else
      render json: @vote.errors, status: :unprocessable_entity
    end

    # If user has voted, destroy the vote
    else
      redirect_to :action=>"destroy" , :comment_id=>params[:comment_id], :up => params[:up]
      return
    end

  end

  # "Unvote" a comment
  def destroy
    @vote = Vote.find_by_comment_id(params[:comment_id])
    # Destroy if the existing vote decision (up/down) agrees with the vote requested to be destroyed
    if @vote.up.to_s==params[:up]
    @vote.destroy
    end
    # Return vote count
    render json: Vote.where(:up=>params[:up]).find_all_by_comment_id(params[:comment_id]).size
  end
end

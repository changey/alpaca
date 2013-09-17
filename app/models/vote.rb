class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment
  validates_uniqueness_of :comment_id, :scope => :user_id     # One user can have only one vote on each comment
  attr_accessible :up             # True for upvote, False for downvote

end

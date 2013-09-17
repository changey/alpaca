class Comment < ActiveRecord::Base
  belongs_to :profile
  has_many :votes
  has_many :users, :through => :votes
  attr_accessible :body, :user_id, :upvote, :downvote, :created_at, :updated_at
  validates :body, :presence => true         # comment body cannot be empty

  # Anonymization of user's facebook id
  def anonymous_id
    User.find(self.user_id).hash.to_s.slice(0,5)+"****"
  end


end

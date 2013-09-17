class Rating < ActiveRecord::Base
  attr_accessible :category, :profile_id, :rate, :user_id
  belongs_to :user, :foreign_key => :user_id
  belongs_to :profile, :foreign_key => :profile_id
  validates :category, :inclusion => {:in => ['Appearances', 'IQ', 'EQ', 'Bangability']}
  validates_uniqueness_of :category, :scope => [:user_id, :profile_id]
end

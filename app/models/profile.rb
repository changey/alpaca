class Profile < ActiveRecord::Base
  attr_accessible :fbid, :total_ratings
  has_many :comments
  has_many :ratings
  has_many :favorites
  has_many :users, :through => :favorites

  validates_uniqueness_of :fbid

  #get the facebook oject for that particular user
  def get_fbobject(session)
  	if session["fb_access_token"].present?
      graph = Koala::Facebook::GraphAPI.new(session["fb_access_token"]) 
      return graph.get_object(self.fbid)
    end
  end

  def self.authorized(session, fbid)
  	if session["fb_access_token"].present?
      graph = Koala::Facebook::GraphAPI.new(session["fb_access_token"]) 
      return ActiveSupport::JSON.decode(graph.get_connections("me", "friends/#{fbid}").to_json) != []
    end
  end

  #get the exsiting rating from the users
  def getRating(session, category)
    if ['Appearances', 'IQ', 'EQ', 'Bangability'].include?(category)
      result = {}
      total = ActiveSupport::JSON.decode(self.total_ratings)
      if total[category]
        result['total'] = total[category]['sum']
        result['number'] = total[category]['number']
      else
        result['total'] = 0
        result['number'] = 0
      end
      user_rating = self.ratings.where(:user_id => session[:user_id], :category => category)
      if !user_rating.empty?
        result['user'] = user_rating[0].rate
      end
      return result
    end
  end

  def add_rating(category, rate)
    if ['Appearances', 'IQ', 'EQ', 'Bangability'].include?(category)
      total = ActiveSupport::JSON.decode(self.total_ratings)
      if !total[category]
        total[category] = {'sum' => 0, 'number' => 0}
      end
      total[category]['sum'] += rate
      total[category]['number'] += 1
      self.update_attribute(:total_ratings, ActiveSupport::JSON.encode(total))
    end
  end

  def delete_rating(category, rate)
    if ['Appearances', 'IQ', 'EQ', 'Bangability'].include?(category)
      total = ActiveSupport::JSON.decode(self.total_ratings)
      if !total[category]
        total[category] = {'sum' => 0, 'number' => 0}
      end
      total[category]['sum'] -= rate
      total[category]['number'] -= 1
      self.update_attribute(:total_ratings, ActiveSupport::JSON.encode(total))
    end
  end

  def update_rating(category, old_rate, new_rate)
    if ['Appearances', 'IQ', 'EQ', 'Bangability'].include?(category)
      total = ActiveSupport::JSON.decode(self.total_ratings)
      if !total[category]
        total[category] = {'sum' => 0, 'number' => 0}
      end
      total[category]['sum'] += (new_rate - old_rate)
      self.update_attribute(:total_ratings, ActiveSupport::JSON.encode(total))
    end
  end

  def getRatings(session)
    categories = ['Appearances', 'IQ', 'EQ', 'Bangability']
    result = {'user' => {}, 'total' => {}}
    total = ActiveSupport::JSON.decode(self.total_ratings)
    categories.each do |category|
      if total[category]
        result['total'][category] = { 
          'total_ratings' => total[category]['sum'], 
          'number_of_ratings' => total[category]['number'] 
        }
      else
        result['total'][category] = { 
          'total_ratings' => 0, 
          'number_of_ratings' => 0 
        }
      end
      user_rating = self.ratings.where(:user_id => session[:user_id], :category => category)
      if !user_rating.empty?
        result['user'][category] = user_rating[0].rate
      end
    end
    return result
  end
end

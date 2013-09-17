class User < ActiveRecord::Base

  attr_accessible :fbid, :gender_pref
  validates_uniqueness_of :fbid
  has_many :favorites
  has_many :profiles,:through => :favorites
  has_many :votes
  has_many :comments, :through => :votes

  def self.create_with_omniauth(auth, fb_token)
    
    create! do |user|
      user.provider = auth['provider']
      user.fbid = auth['uid']
      if auth['info']
        user.name = auth['info']['name'] || ""
        user.email = auth['info']['email'] || ""
        user.token = auth['credentials']['token']
        
      end
    end
  end
 
  def getFriends(session)
    friends = Array.new
    if session["fb_access_token"].present?
      graph = Koala::Facebook::GraphAPI.new(session["fb_access_token"]) # Note that session is used heres
      fbobjects = ActiveSupport::JSON.decode(graph.get_connections("me", "friends",:fields=>"name,gender").to_json)
      friends = Array.new

      if self.gender_pref.nil?
        if self.gender == 'male'
          displayed_gender = 'female'
        else
          displayed_gender = 'male'
        end
      else 
        displayed_gender = self.gender_pref
      end
      
      fbobjects.each_with_index do |fbobject, index|
        if fbobject['gender'] == displayed_gender
          friends.push({'fbid' => fbobject['id'], 'name' => fbobject['name'], 'gender' => fbobject['gender']})
        end
      end
      ids = Array.new
      inds = {}
      friends.each_with_index do |friend, index|
        ids.push(friend['fbid'])
        inds[friend['fbid']] = index
      end
      profiles = Profile.where(:fbid => ids)
      profiles.each do |profile|
        friends[inds[profile.fbid]]['id'] = profile.id
      end
    end
    return friends.to_json
  end

  def showFriends(session,id)
    @user = User.find(id)

    if @user.friend_list.nil?
      friendList = getFriends(session)
      @user.friend_list = friendList.to_s
      @user.save
    end
    return JSON.parse(@user.friend_list)
  end

  #Return average rating for the friends
  def showFriendsKeys(session, key)
    friends = Array.new
    if session["fb_access_token"].present?
      if self.gender_pref.nil?
        if self.gender == 'male'
          displayed_gender = 'female'
        else
          displayed_gender = 'male'
        end
      else 
        displayed_gender = self.gender_pref
      end
      friends = self.showFriends(session, self.id)
      ids = Array.new
      inds = {}
      friends.each_with_index do |friend, index|
        ids.push(friend['fbid'])
        inds[friend['fbid']] = index
      end
      profiles = Profile.where(:fbid => ids)
      profiles.each do |profile|
        friends[inds[profile.fbid]]['id'] = profile.id
        if ['Appearances', 'IQ', 'EQ', 'Bangability'].include?(key)
          profile_total = ActiveSupport::JSON.decode(profile.total_ratings)
          if profile_total[key]
            total = profile_total[key]['sum']
            count = profile_total[key]['number']
          else
            total = 0
            count = 0
          end
          if count != 0
            avg = total / count
          else
            avg = 0.0
          end
        end
        friends[inds[profile.fbid]]['key'] = avg
      end
    end
    return friends.to_json
  end
  
  def getGender(id)
    @user = User.find(id)
    return "{\"gender\":\""+@user.gender+"\"}"
  end

  def filterFriends(session, json_conditions)
    if self.friend_list.nil?
      friendList = getFriends(session)
      self.friend_list = friendList.to_s
      self.save
    end
    friends = ActiveSupport::JSON.decode(self.friend_list)
    conditions = ActiveSupport::JSON.decode(json_conditions)
    parsed_conditions = {'Appearances' => {}, 'IQ' => {}, 'EQ' => {}, 'Bangability' => {}}
    ids = Array.new
    inds = {}
    friends.each_with_index do |friend, index|
      ids.push(friend['fbid'])
      inds[friend['fbid']] = index
    end
    profiles = Profile.where(:fbid => ids)
    filter_result = Array.new
    profiles.each do |profile|
      satisfied = true
      conditions.each do |condition|
        logger.debug "The codition is " + condition.to_s
        total = ActiveSupport::JSON.decode(profile.total_ratings)
        if ['at least', 'at most'].include?(condition['condition']) && ['Appearances', 'IQ', 'EQ', 'Bangability'].include?(condition['category'])
          if total[condition['category']]
            if total[condition['category']]['number'] != 0
              avg = total[condition['category']]['sum'] / total[condition['category']]['number']
            else
              avg = 0
            end
          else
            avg = 0
          end
          logger.debug "Condition " + condition['condition'] +". Stars " + condition['star']
          if condition['condition'] == 'at least' && avg < condition['star'].to_f
            satisfied = false
          elsif condition['condition'] == 'at most' && avg > condition['star'].to_f
            satisfied = false
          end
        end
      end
      if satisfied
        filter_result.push(friends[inds[profile.fbid]])
      end
    end
    return filter_result.to_json
  end
end

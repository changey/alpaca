namespace :db do
  desc "Fill database with sample data"
  task :populate=> :environment do
    make_comments
  end
end
 
  def make_comments
    profiles = Profile.all(:limit=> 6)
    50.times do
      comment = Faker::Lorem.sentence(5)
      profiles.each { |profile| profile.comments.create!(:body=> comment) }
    end
  end

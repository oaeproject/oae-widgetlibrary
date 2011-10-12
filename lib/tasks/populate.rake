namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'ffaker'
    [Widget, User, Rating].each(&:delete_all)
    User.populate 25 do |user|
      user.email              = Faker::Internet.email
      user.admin              = 0
      user.reviewer           = 0
      user.username           = Faker::Internet.user_name
      user.first_name         = Faker::Name.first_name
      user.last_name          = Faker::Name.first_name
      user.info               = Faker::Lorem.sentence(20)
      user.summary            = Faker::Lorem.sentence(20)
      user.occupation         = Faker::Lorem.words(2).collect!{|t| t.capitalize }.join(' ')
      user.homepage           = Faker::Internet.domain_name
      user.location           = Faker::Address.city
      user.encrypted_password = Faker::Lorem.words(1).join(' ')
      Widget.populate 4 do |widget|
        widget.title          = Faker::Lorem.words(2).collect!{|t| t.capitalize }.join(' ')
        widget.description    = Faker::Lorem.sentence(20)
        widget.features       = Faker::Lorem.words(5).collect!{|t| t.capitalize }.join(' ')
        widget.released_on    = Time.now
        Rating.populate ((rand*20).round+1) do |rating|
          rating.review       = Faker::Lorem.sentence(20)
          # Create a weighted array of ratings, so we get fewer 0 and 1 ratings, and more 4 and 5s
          rating_arr = [0,0,1,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5]
          rating.stars        = rating_arr[(rand*rating_arr.length-1).round]
          rating.widget_id    = widget.id
          rating.user_id      = (rand*25).round
        end
        widget.state_id       = (rand*2).round
        widget.user_id        = user.id
        widget.created_at     = Time.now
        widget.updated_at     = Time.now
      end
    end

    Widget.all.each do |widget|
      total_stars = 0
      widget.ratings.each do |rating|
        total_stars += rating.stars
      end
      widget.average_rating = (total_stars.to_f / widget.ratings.length.to_f).round(1)
      widget.icon = File.open(Dir.glob(File.join(Rails.root, 'test/sampledata/images', "#{1+rand(10)}.png")).sample)
      widget.code = File.open(Dir.glob(File.join(Rails.root, 'test/sampledata/zip', '*')).sample)
      widget.save!
    end
    User.all.each do |user|
      user.avatar = File.open(Dir.glob(File.join(Rails.root, 'test/sampledata/images', "#{1+rand(10)}.png")).sample)
      user.save!
    end
  end
end

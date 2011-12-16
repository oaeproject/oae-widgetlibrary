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
      user.name               = "#{user.first_name} #{user.last_name}"
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
        released_on = Time.now - rand(50000000)
        widget.released_on    = released_on
        num_ratings = rand(20) + 1
        ratings = []
        count = 1
        seed = rand(25) + 1
        Rating.populate (num_ratings) do |rating|
          rating.review       = Faker::Lorem.sentence(20)
          # Create a weighted array of ratings, so we get fewer 0 and 1 ratings, and more 4 and 5s
          rating_arr          = [0,0,1,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5]
          rating.stars        = rating_arr[rand(rating_arr.length-1)]
          rating.widget_id    = widget.id
          rating.user_id      = ((seed + count) % 25) + 1
          time = released_on - rand(50000000)
          rating.created_at   = time
          rating.updated_at   = time
          ratings.push(rating)
          count += 1
        end
        total_stars = 0
        ratings.each do |rating|
          total_stars += rating.stars
        end
        widget.average_rating = total_stars.to_f / num_ratings.to_f
        widget.state_id       = rand(2) + 1
        widget.user_id        = user.id
        time                  = Time.now - rand(50000000)
        widget.created_at     = time
        widget.updated_at     = time
      end
    end

    Widget.all.each do |widget|
      widget.icon = File.open(Dir.glob(File.join(Rails.root, 'test/sampledata/images', "#{1+rand(10)}.png")).sample)
      widget.code = File.open(Dir.glob(File.join(Rails.root, 'test/sampledata/zip', '*')).sample)
      rand(4).times do
        screenshot = Screenshot.new
        screenshot.image = File.open(Dir.glob(File.join(Rails.root, 'test/sampledata/screenshots', "#{1+rand(9)}.png")).sample)
        screenshot.widget_id = widget.id
        screenshot.save!
      end
      widget.save!
    end
    User.all.each do |user|
      user.avatar = File.open(Dir.glob(File.join(Rails.root, 'test/sampledata/images', "#{1+rand(10)}.png")).sample)
      user.save!
    end
  end
end

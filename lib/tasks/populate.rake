namespace :db do

  NUM_DUMMY_USERS = 25
  NUM_WIDGETS_PER_USER = 4
  NUM_USERS = 5

  def create_rating(widgetid, released_on)
    ret = false

    created = released_on - rand(50000000)
    # Create a weighted array of ratings, so we get fewer 0 and 1 ratings, and more 4 and 5s
    rating_arr  = [0,0,1,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5]

    Rating.populate 1 do |rating|
      rating.review       = Faker::Lorem.sentence(rand(50)+20)
      rating.stars        = rating_arr[rand(rating_arr.length-1)]
      rating.widget_id    = widgetid
      rating.user_id      = rand(NUM_DUMMY_USERS) + 1
      rating.created_at   = created
      rating.updated_at   = created
      ret = rating
    end

    ret
  end

  def generate_title
    Faker::Lorem.words(rand(5) + 1).collect!{|t| t.capitalize }
  end

  def generate_url_title(title)
    title.collect{|t| t.downcase}.join('-')
  end

  $widget_titles = []
  $widget_urls = []

  def create_widget(userid)
    ret = false

    released_on = Time.now - rand(50000000)
    num_ratings = rand(20) + 1
    created = Time.now - rand(50000000)
    state = rand(3) + 1
    title = generate_title
    url_title = generate_url_title(title)
    while $widget_titles.include?(title.join(' ')) || $widget_urls.include?(url_title)
      title = generate_title
      url_title = generate_url_title(title)
    end
    $widget_titles.push(title.join(' '))
    $widget_urls.push(url_title)
    Widget.populate 1 do |widget|
      widget.title          = title.join(' ')
      widget.url_title      = url_title
      widget.description    = Faker::Lorem.sentence(rand(50) + 20)
      widget.features       = Faker::Lorem.words(rand(20) + 1).collect!{|t| t.capitalize }.join(' ')
      widget.released_on    = released_on
      ratings = []
      num_ratings.times do
        ratings.push(create_rating(widget.id, released_on))
      end
      total_stars = 0
      ratings.each do |rating|
        total_stars += rating.stars
      end
      widget.average_rating = total_stars.to_f / num_ratings.to_f
      widget.state_id       = state
      widget.user_id        = userid
      widget.created_at     = created
      widget.updated_at     = created
      ret = widget
    end

    ret
  end

  def populate_widget_data
    num_categories = Category.count
    num_languages = Language.count

    Widget.all.each do |widget|
      icon = File.open(Dir.glob(File.join(Rails.root, 'test/sampledata/images', "#{1+rand(10)}.png")).sample)
      widget.icon = icon
      icon.close

      code = File.open(Dir.glob(File.join(Rails.root, 'test/sampledata/zip', '*')).sample)
      widget.code = code
      code.close

      category_ids = []
      rand(5).times do
        category_ids.push( rand(num_categories) + 1 )
      end
      widget.category_ids = category_ids

      language_ids = []
      rand(4).times do
        language_ids.push( rand(num_languages) + 1 )
      end
      widget.language_ids = language_ids

      rand(4).times do
        screenshot = Screenshot.new
        image = File.open(Dir.glob(File.join(Rails.root, 'test/sampledata/screenshots', "#{1+rand(9)}.png")).sample)
        screenshot.image = image
        screenshot.widget_id = widget.id
        screenshot.save!
        image.close
      end
      widget.save!
    end
  end

  $usernames = []
  $names = []

  def create_dummy_user
    username = Faker::Internet.user_name
    first_name = Faker::Name.first_name
    last_name  = Faker::Name.last_name
    name = "#{first_name} #{last_name}"
    while $usernames.include?(username) || $names.include?(name)
      username = Faker::Internet.user_name
      first_name = Faker::Name.first_name
      last_name  = Faker::Name.last_name
      name = "#{first_name} #{last_name}"
    end
    $usernames.push(username)
    $names.push(name)
    User.populate 1 do |user|
      user.email              = Faker::Internet.email
      user.admin              = 0
      user.reviewer           = 0
      user.username           = username
      user.first_name         = first_name
      user.last_name          = last_name
      user.name               = name
      user.url_title          = "#{user.first_name.downcase}-#{user.last_name.downcase}"
      user.info               = Faker::Lorem.sentence(rand(50) + 20)
      user.summary            = Faker::Lorem.sentence(rand(50) + 20)
      user.occupation         = Faker::Lorem.words(rand(6) + 1).collect!{|t| t.capitalize }.join(' ')
      user.homepage           = "http://#{Faker::Internet.domain_name}"
      user.location           = Faker::Address.city
      user.encrypted_password = Faker::Lorem.words(1).join(' ')
      NUM_WIDGETS_PER_USER.times do
        create_widget(user.id)
      end
    end
  end

  def create_real_user(i)
    params = {
      :email => "user#{i}@sakaiproject.invalid",
      :admin => false,
      :reviewer => false,
      :username => "user#{i}",
      :password => "test",
      :password_confirmation => "test",
      :first_name => "User",
      :last_name => i,
      :url_title => "user-#{i}",
      :name => "User #{i}",
      :info => Faker::Lorem.sentence(rand(50) + 20),
      :summary => Faker::Lorem.sentence(rand(50) + 20),
      :occupation => Faker::Lorem.words(rand(6) + 1).collect!{|t| t.capitalize }.join(' '),
      :homepage => "http://#{Faker::Internet.domain_name}",
      :location => Faker::Address.city
    }
    user = User.new(params)
    user.save!
    10.times do
      create_widget(user.id)
    end
  end

  def give_users_avatars
    User.all.each do |user|
      avatar = File.open(Dir.glob(File.join(Rails.root, 'test/sampledata/images', "#{1+rand(10)}.png")).sample)
      user.avatar = avatar
      user.save!
      avatar.close
    end
  end

  desc "Erase and populate the database for development"
  task :populate => :environment do
    require 'populator'
    require 'ffaker'

    # Drop all the existing tables
    [Widget, User, Rating].each(&:delete_all)

    NUM_DUMMY_USERS.times do
      create_dummy_user
    end

    NUM_USERS.times do |i|
      create_real_user(i+1)
    end

    give_users_avatars

    populate_widget_data

  end
end

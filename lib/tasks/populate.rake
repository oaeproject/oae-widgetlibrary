namespace :db do

  NUM_DUMMY_USERS = 25
  NUM_WIDGETS_PER_USER = 4
  NUM_USERS = 10

  def create_rating(widgetid, released_on)
    ret = false

    created = rand(released_on..(Time.now-10000))
    # Create a weighted array of ratings, so we get fewer 0 and 1 ratings, and more 4 and 5s
    rating_arr  = [1,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5]

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
    num_ratings = rand(20) + 1
    created = Time.now - 10000 - rand(50000000)

    title = generate_title
    url_title = generate_url_title(title)

    while $widget_titles.include?(title.join(' ')) || $widget_urls.include?(url_title)
      title = generate_title
      url_title = generate_url_title(title)
    end

    $widget_titles.push(title.join(' '))
    $widget_urls.push(url_title)

    reviewers = User.where(:reviewer => true).collect{ |u| u.id }

    Widget.populate 1 do |widget|


      widget.url_title      = url_title
      widget.user_id        = userid

      activeVersion = false
      count = 1
      num_versions = 1+rand(4)
      Version.populate num_versions do |version|
        created = rand(created..(Time.now-10000))
        version.title          = title.join(' ')
        version.description    = Faker::Lorem.sentence(rand(50) + 20)
        version.features       = Faker::Lorem.words(rand(20) + 1).collect!{|t| t.capitalize }.join(' ')
        version.state_id       = rand(3) + 1
        version.created_at     = created
        version.updated_at     = created
        version.widget_id      = widget.id
        version.version_number = "#{count}.0"
        if version.state_id.eql?(State.accepted)
          count += 1
          activeVersion        = version
          version.released_on  = rand(created..(Time.now-10000))
        end
        if version.state_id.eql?(State.accepted) || version.state_id.eql?(State.declined)
          version.notes        = Faker::Lorem.sentence(rand(50) + 20)
          version.user_id      = reviewers.sample
          version.reviewed_on  = Time.now
        end
      end

      if activeVersion
        widget.version_id = activeVersion.id
        widget.active = true
        ratings = []
        total_stars = 0
        num_ratings.times do
          rating = create_rating(widget.id, activeVersion.released_on)
          ratings.push(rating)
          total_stars += rating.stars
        end
        widget.average_rating = total_stars.to_f / num_ratings.to_f
      else
        widget.active = false
      end

      ret = widget
    end

    ret
  end

  def populate_widget_data
    num_categories = Category.count
    num_languages = Language.count

    Version.find_each do |version|
      icon = File.open(Dir.glob(File.join(Rails.root, 'test/sampledata/images', "#{1+rand(10)}.png")).sample)
      version.icon = icon
      icon.close

      code = File.open(Dir.glob(File.join(Rails.root, 'test/sampledata/zip', '*')).sample)
      version.code = code
      code.close

      if rand(2).eql? 1
        bundle = File.open(Dir.glob(File.join(Rails.root, 'test/sampledata/zip', '*')).sample)
        version.bundle = bundle
        bundle.close
      end

      category_ids = []
      rand(5).times do
        cat_id = rand(num_categories) + 1
        while category_ids.include?(cat_id)
          cat_id = rand(num_categories) + 1
        end
        category_ids.push( cat_id )
      end
      version.category_ids = category_ids

      language_ids = []
      rand(4).times do
        lang_id = rand(num_languages) + 1
        while language_ids.include?(lang_id)
          lang_id = rand(num_languages) + 1
        end
        language_ids.push( lang_id )
      end
      version.language_ids = language_ids

      rand(4).times do
        screenshot = Screenshot.new
        image = File.open(Dir.glob(File.join(Rails.root, 'test/sampledata/screenshots', "#{1+rand(9)}.png")).sample)
        screenshot.image = image
        screenshot.version_id = version.id
        screenshot.save!
        image.close
      end
      version.save!
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
      user.admin              = false
      user.reviewer           = false
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
    user.admin = true
    user.reviewer = true
    user.save!
  end

  def give_users_avatars
    User.find_each do |user|
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

    NUM_USERS.times do |i|
      create_real_user(i+1)
    end

    NUM_USERS.times do |i|
      user = User.where(:username => "user#{i+1}").first
      NUM_WIDGETS_PER_USER.times do
        create_widget(user.id)
      end
    end

    NUM_DUMMY_USERS.times do
      create_dummy_user
    end

    give_users_avatars

    populate_widget_data

  end
end

include ActionDispatch::TestProcess

FactoryGirl.define do

  factory :rating do
    review "This is a super awesome widget, I use it every day and get a warm fuzzy feeling"
    stars 5
    widget
  end

  factory :screenshot do
    image fixture_file_upload(Rails.root.to_s + '/test/fixtures/images/1.png', 'image/png')
    version
  end

  factory :user do
    sequence(:username) { |n| "testuser#{n}" }
    first_name "Testuser"
    sequence(:last_name) { |n| "#{n}" }
    sequence(:email) { |n| "testuser#{n}@example.com" }
    password "test"
    password_confirmation "test"
    avatar fixture_file_upload(Rails.root.to_s + '/test/fixtures/images/1.png', 'image/png')
  end

  factory :widget do
    sequence(:url_title) { |n| "awesome-widget-#{n}" }
    average_rating 5.0
    active true
    num_downloads 5
    num_ratings 5
    user
  end

  factory :version do
    title "Awesome Widget"
    description "A widget that gives you a warm fuzzy feeling."
    features "warmth, fuzziness"
    version_number "1.0"
    released_on Time.now
    widget_repo "http://github.com/sakaiproject/3akai-ux"
    widget_backend_repo "http://github.com/sakaiproject/nakamura"
    icon fixture_file_upload(Rails.root.to_s + '/test/fixtures/images/1.png', 'image/png')
    code fixture_file_upload(Rails.root.to_s + '/test/fixtures/zip/1.png.zip', 'application/zip')
    user
  end

end

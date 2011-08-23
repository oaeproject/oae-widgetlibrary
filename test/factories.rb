include ActionDispatch::TestProcess

Factory.define :category do |f|
  f.sequence(:title) { |n| "Category #{n}" }
end

Factory.define :language do |f|
  f.title "English (US)"
  f.code "en"
  f.region "us"
end

Factory.define :rating do |f|
  f.review "This is a super awesome widget, I use it every day and get a warm fuzzy feeling"
  f.stars 5
  f.association :widget
end

Factory.define :screenshot do |f|
  f.association :widget
  f.image fixture_file_upload(Rails.root.to_s + '/test/fixtures/test.png', 'image/png')
end

Factory.define :state do |f|
  f.title "accepted"
  f.after_create { |s| Factory(:widget, :state => s) }
end

Factory.define :user do |f|
  f.username "user1"
  f.first_name "User"
  f.last_name "One"
  f.email "user1@example.com"
  f.avatar fixture_file_upload(Rails.root.to_s + '/test/fixtures/test.png', 'image/png')
end

Factory.define :widget do |f|
  f.title "Awesome Widget"
  f.description "A widget that gives you a warm fuzzy feeling."
  f.features "warmth, fuzziness"
  f.average_rating 5.0
  f.association :state
  f.icon fixture_file_upload(Rails.root.to_s + '/test/fixtures/test.png', 'image/png')
  f.code fixture_file_upload(Rails.root.to_s + '/test/fixtures/test.png.zip', 'application/zip')
  f.after_create { |w| Factory(:rating, :widget => w) }
  f.after_create { |w| Factory(:screenshot, :widget => w) }
end

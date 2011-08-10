Factory.define :category do |f|
  f.sequence(:title) { |n| "Category #{n}" }
end

Factory.define :icon do |f|
  f.association :widget
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
end

Factory.define :state do |f|
  f.title "accepted"
  f.after_create { |s| Factory(:widget, :state => s) }
end

Factory.define :widget do |f|
  f.title "Awesome Widget"
  f.description "A widget that gives you a warm fuzzy feeling."
  f.features "warmth, fuzziness"
  f.average_rating 5.0
  f.association :state
  f.after_create { |w| Factory(:rating, :widget => w) }
  f.after_create { |w| Factory(:screenshot, :widget => w) }
end

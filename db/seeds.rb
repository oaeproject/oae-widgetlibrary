# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Create the default states
State.create(:title => "accepted", :id => 1)
State.create(:title => "pending", :id => 2)
State.create(:title => "declined", :id => 3)

# Create a starting set of categories
Category.create(:title =>"Games")
Category.create(:title =>"Quizzes")
Category.create(:title =>"Feeds, News + Blogging")
Category.create(:title =>"Social + Communication")
Category.create(:title =>"Video + images")
Category.create(:title =>"Graphing")
Category.create(:title =>"Utilities")
Category.create(:title =>"Other")

# Create some languages
Language.create(:title => "English (US)", :code => "en", :region => "US")
Language.create(:title => "English (UK)", :code => "en", :region => "GB")
Language.create(:title => "French", :code => "fr", :region => "FR")
Language.create(:title => "Netherlands", :code => "nl", :region => "NL")
Language.create(:title => ">日本語", :code => "jp", :region => "JP")
Language.create(:title => "中文", :code => "zh", :region => "CN")
Language.create(:title => "한국어", :code => "ko", :region => "KR")
Language.create(:title => "Magyar", :code => "hu", :region => "HU")
Language.create(:title => "Spanish", :code => "es", :region => "ES")

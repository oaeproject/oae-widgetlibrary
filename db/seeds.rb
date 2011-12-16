# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

State.create(:title => "accepted")
State.create(:title => "pending")
State.create(:title => "declined")

Category.create(:title => "Games")
Category.create(:title => "Quizzes")
Category.create(:title => "Feeds, News + Bloggig")
Category.create(:title => "Social + Communication")
Category.create(:title => "Video + Images")
Category.create(:title => "Graphing")
Category.create(:title => "Utilities")
Category.create(:title => "Other")

Language.create(:title => "English (US)")
Language.create(:title => "English (UK)")
Language.create(:title => "English (AU)")
Language.create(:title => "French")
Language.create(:title => "Spanish")
Language.create(:title => "Portugese")
Language.create(:title => "Dutch")
Language.create(:title => "German")
Language.create(:title => "Japanese")
Language.create(:title => "Icelandic")
Language.create(:title => "Russian")
Language.create(:title => "Italian")

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

include ActionView::Helpers::TextHelper

10.times {User.create!(email: Faker::Internet.unique.email, password: Faker::Internet.password)}

users = User.all

50.times {users.sample.wikis.create!(title: Faker::Lorem.sentence(2), body: Faker::Lorem.paragraph)}

puts "Created #{pluralize(User.all.count, 'user')}"
puts "Created #{pluralize(Wiki.all.count, 'wiki')}"

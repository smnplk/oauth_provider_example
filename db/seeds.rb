# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
  User.create(email: 'user@email.com', password: 'password123', password_confirmation: 'password123')
  Contact.create([{name: "John Doe", phone: "0882-232-232"}, {name: "Diana Krall", phone: "0823-232-323"}])

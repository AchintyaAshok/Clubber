# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

WebsterHall = Venue.create!(name: 'Webster Hall', address: '125 East 11th Street, New York, NY 10003')
TurtleBay = Venue.create!(name: 'Turtle Bay Tavern', address: '987 2nd Avenue, Manhattan, NY 10022')
Pacha = Venue.create!(name: 'Club Pacha', address: '618 West 46th Street, New York, NY 10036')
JosieWoods = Venue.create!(name: 'Josie Woods Pub', address: '11 Waverly Place, New York, NY 10003')
TomorrowLand = Venue.create!(name: 'Tomorrowland', address: 'Dirkputstraat 260, 2850, Boom, Belgium')

FirstEvent = Event.create!(
	name: 'First Club Event!', 
	description: 'lorem ipsum',
	begins: DateTime.new(2014, 8, 14, 20, 0), #starts at 10pm
	ends: DateTime.new(2014, 8, 15, 2, 0) #ends at 2am
)
FirstEvent.venue = WebsterHall
FirstEvent.save!
# FirstEvent.venue = WebsterHall
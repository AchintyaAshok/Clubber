# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

WebsterHall = Venue.find_or_create_by_name!(name: 'Webster Hall', address: '125 East 11th Street, New York, NY 10003')
TurtleBay = Venue.find_or_create_by_name!(name: 'Turtle Bay Tavern', address: '987 2nd Avenue, Manhattan, NY 10022')
Pacha = Venue.find_or_create_by_name!(name: 'Club Pacha', address: '618 West 46th Street, New York, NY 10036')
JosieWoods = Venue.find_or_create_by_name!(name: 'Josie Woods Pub', address: '11 Waverly Place, New York, NY 10003')
TomorrowLand = Venue.find_or_create_by_name!(name: 'Tomorrowland', address: 'Dirkputstraat 260, 2850, Boom, Belgium')

FirstEvent = Event.find_or_create_by_name!(
	name: 'First Club Event!', 
	description: 'lorem ipsum',
	begins: DateTime.new(2014, 8, 14, 20, 0), #starts at 10pm
	ends: DateTime.new(2014, 8, 15, 2, 0) #ends at 2am
)
FirstEvent.venue = WebsterHall
FirstEvent.save!

#TestMedia = Media.find_or_create_by_name(name: "first media thing!", location: '~/Desktop/test.jpeg', size: 843776)
TestMedia = FirstEvent.media.find_or_create_by_name(name: "Event1's file", location: '~/Desktop/test.jpeg', size: 843776)
FirstEvent.media.find_or_create_by_name(name: "Webster1", location:'/Users/achintyaashok/Documents/My Projects/Clubber/MediaFiles/EventMedia/webster.jpg', size: 500000)
FirstEvent.media.find_or_create_by_name(name: "Webster2", location:'/Users/achintyaashok/Documents/My Projects/Clubber/MediaFiles/EventMedia/webster2.jpg', size: 500000)
FirstEvent.media.find_or_create_by_name(name: "Webster3", location:'/Users/achintyaashok/Documents/My Projects/Clubber/MediaFiles/EventMedia/webster3.jpg', size: 500000)


Event2 = Event.find_or_create_by_name!(
	name: 'Happy Hour Special', 
	description: 'lorem ipsum',
	begins: DateTime.new(2014, 8, 14, 20, 0), #starts at 10pm
	ends: DateTime.new(2014, 8, 15, 2, 0) #ends at 2am
)
Event2.venue = TurtleBay
Event2.save!

Event3 = Event.find_or_create_by_name!(
	name: 'Sesbastian Ingrosso @ Pacha NYC', 
	description: 'lorem ipsum',
	begins: DateTime.new(2014, 8, 14, 20, 0), #starts at 10pm
	ends: DateTime.new(2014, 8, 15, 2, 0) #ends at 2am
)
Event3.venue = Pacha
Event3.save!

Event4 = Event.find_or_create_by_name!(
	name: 'Pool & Drinks', 
	description: 'lorem ipsum',
	begins: DateTime.new(2014, 8, 14, 20, 0), #starts at 10pm
	ends: DateTime.new(2014, 8, 15, 2, 0) #ends at 2am
)
Event4.venue = JosieWoods
Event4.save!

commentA = Comment.find_or_create_by_text!(event_id: 1, text: "this is the first comment ever.")
commentB = Comment.find_or_create_by_text!(event_id: 1, text: "second!")
commentC = Comment.find_or_create_by_text!(event_id: 1, text: "the awkward third comment")


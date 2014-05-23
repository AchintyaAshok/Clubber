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
	description: 'Aliquam erat turpis, euismod sit amet tincidunt ut, convallis eu mi. Mauris dignissim eleifend nisl vel tincidunt. Praesent quis tortor dignissim nunc ultrices volutpat eget at mi. Nulla sit amet arcu lacus. Vestibulum eget lacus sagittis, lacinia nibh vel, consectetur felis. In sed diam euismod, facilisis orci vel, congue dolor.',
	begins: DateTime.new(2014, 8, 14, 20, 0), #starts at 10pm
	ends: DateTime.new(2014, 8, 15, 2, 0) #ends at 2am
)
FirstEvent.venue = WebsterHall
FirstEvent.save!

#TestMedia = Media.find_or_create_by_name(name: "first media thing!", location: '~/Desktop/test.jpeg', size: 843776)
TestMedia = FirstEvent.media.find_or_create_by_name(
	name: "Event1's file", 
	location: '~/Desktop/test.jpeg', 
	size: 843776
)
FirstEvent.media.find_or_create_by_name(
	name: "Webster1", 
	location:'/Users/achintyaashok/Documents/My Projects/Clubber/MediaFiles/EventMedia/webster.jpg', 
	size: 500000
)
FirstEvent.media.find_or_create_by_name(
	name: "Webster2", 
	location:'/Users/achintyaashok/Documents/My Projects/Clubber/MediaFiles/EventMedia/webster2.jpg', 
	size: 500000
)
FirstEvent.media.find_or_create_by_name(
	name: "Webster3", 
	location:'/Users/achintyaashok/Documents/My Projects/Clubber/MediaFiles/EventMedia/webster3.jpg', 
	size: 500000
)


Event2 = Event.find_or_create_by_name!(
	name: 'Happy Hour Special', 
	description: 'Aliquam in commodo sem. Aenean tempus nibh vitae pretium molestie. Nam auctor, massa at vehicula dapibus, tortor nulla venenatis sapien, eleifend elementum nunc nibh eget ipsum. Quisque ullamcorper augue vel nunc lacinia, quis placerat ante venenatis. Aliquam porta laoreet neque. Aenean vel ornare sapien. Nulla facilisi. Praesent nec gravida tellus. Vestibulum accumsan augue lacus, nec iaculis mauris sodales vel.',
	begins: DateTime.new(2014, 8, 14, 20, 0), #starts at 10pm
	ends: DateTime.new(2014, 8, 15, 2, 0) #ends at 2am
)
Event2.venue = TurtleBay
Event2.save!

Event3 = Event.find_or_create_by_name!(
	name: 'Sesbastian Ingrosso @ Pacha NYC', 
	description: 'Donec elit nisl, laoreet eu est et, tempus sagittis ipsum. Praesent luctus rhoncus ornare. Quisque auctor leo lorem, facilisis commodo quam blandit vel. Integer condimentum, diam eu congue vestibulum, ligula risus viverra tellus, rhoncus scelerisque arcu diam nec elit. Quisque lacinia nec ante id varius. Phasellus sodales scelerisque nibh, eu semper erat adipiscing eu. Vestibulum eu lacus nulla.',
	begins: DateTime.new(2014, 8, 14, 20, 0), #starts at 10pm
	ends: DateTime.new(2014, 8, 15, 2, 0) #ends at 2am
)
Event3.venue = Pacha
Event3.save!

Event3.media.find_or_create_by_name(
	name: "Pacha1", 
	location:'/Users/achintyaashok/Documents/My Projects/Clubber/MediaFiles/EventMedia/pacha.jpg', 
	size: 500000
)
Event3.media.find_or_create_by_name(
	name: "Pacha2", 
	location:'/Users/achintyaashok/Documents/My Projects/Clubber/MediaFiles/EventMedia/pacha2.jpg', 
	size: 500000
)
Event3.media.find_or_create_by_name(
	name: "Pacha3", 
	location:'/Users/achintyaashok/Documents/My Projects/Clubber/MediaFiles/EventMedia/pacha3.jpg', 
	size: 500000
)



Event4 = Event.find_or_create_by_name!(
	name: 'Pool & Drinks', 
	description: 'Aenean vel ornare sapien. Nulla facilisi. Praesent nec gravida tellus. Vestibulum accumsan augue lacus, nec iaculis mauris sodales vel. Donec elit nisl, laoreet eu est et, tempus sagittis ipsum. Praesent luctus rhoncus ornare. Quisque auctor leo lorem, facilisis',
	begins: DateTime.new(2014, 8, 14, 20, 0), #starts at 10pm
	ends: DateTime.new(2014, 8, 15, 2, 0) #ends at 2am
)
Event4.venue = JosieWoods
Event4.save!

commentA = Comment.find_or_create_by_text!(
	event_id: 1, 
	text: "this is the first comment ever."
)
commentB = Comment.find_or_create_by_text!(
	event_id: 1, 
	text: "second!"
)
commentC = Comment.find_or_create_by_text!(
	event_id: 1, 
	text: "the awkward third comment"
)


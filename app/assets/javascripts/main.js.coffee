jQuery ->

	class MainRouter extends Backbone.Router
		routes:
			'' : 'home'
			# 'find_table' : 'table_view'
			# 'select_items': 'menu_view'


		# Basically a constructor for the AppRouter, this method retrieves the collection
		# of all events (without any filters) and the list of categories. 
		initialize: ->
			@currentView = null
			# window.App.VenmoUser = new User
			# window.App.vent.bind('table-selection', @table_view)


		show_view:(newView) =>
			#console.log 'in show view'
			if @currentView is not null then @currentView.close()
			@currentView = newView
			$('#container-main').html @currentView.render().el


		home: ->
			#console.log 'in home!'
			view = new Home
			view.fetch_information()
			@show_view(view)


		###
		table_view: =>
			console.log 'in table view'
			@navigate('makeMyTable')
			view = new TableView
			@show_view(view)

		menu_view:(id) =>
			console.log('get_menu', id)
			menuView = new MenuView
				id: id
			@navigate('select_items/' + id)
			@show_view(menuView)
		###


	class Home extends Backbone.View
		tagName: 'div'

		initialize: =>
			console.log "initialize backbone view -> Home"

		fetch_information: =>
			#console.log 'fetching information for home view'
			@events = new EventCollection
			@events.fetch
				async: false
				success:(ev) ->
					#console.log 'yay fetched my shit!'
					return @
				error:(response) ->
					console.log 'Did not fetch events: ', response

		render: ->
			#console.log 'in home render', @events
			template = '''<h>WELCOME</h>'''
			eventViewItems = []
			for elem in @events.models
				newView = new EventView
					model: elem
				eventViewItems.push newView #add it to our list of managed event views

			console.log 'list of views managed: ', eventViewItems

			$(@el).html(_.template(template))
			@	# last statement returns this

		close: ->
			@remove()


	class EventView extends Backbone.View

		initialize:(options) =>
			#console.log 'initialize eventView: ', options
			@model = options.model
			@listenTo(this.model, "change", this.render) #when the model is modified, we update the view
			#console.log 'initializing event view'
			#console.log "event view model: ", @model

		render: ->



	class Event extends Backbone.Model
		url: '/events'

		initialize:(options) ->
			#console.log 'intialized event: ', @id
			@mediaObjects = new MediaCollection
				event_id: @id
			@mediaObjects.fetch
				async: true
				success:(eve) ->
				error:(res) ->
					console.log 'Did not fetch Media Files: ', res
			@comments = new CommentCollection
				event_id: @id
			@comments.fetch
				async: true 
				success:(e) ->
				error:(e) ->
					console.log 'Did not fetch Comments: ', e

			#console.log 'event obj: ', @


	
	class EventCollection extends Backbone.Collection
		url: '/events'
		model: Event


	class Media extends Backbone.Model
		url: '/media'

		initialize:(options) ->
			#console.log 'initialized Media obj', options
			if options? and options.event_id?
				@event_id = options.event_id

	class MediaCollection extends Backbone.Collection
		url: '/media'
		model: Media

		initialize:(options) =>
			#console.log 'initialize MediaFiles with options: ', options
			@event_id = options.event_id
			@url = "/events/" + @event_id + "/media"
			#console.log 'modified media-files url: ', @url
			@


	class Comment extends Backbone.Model
		url: '/comments'

		initialize:(options) ->
			if options? and options.event_id?
				@url = '/events/' + options.event_id + '/comments/' + @id

	class CommentCollection extends Backbone.Collection
		url: '/comments'
		model: Comment

		initialize:(options) =>
			#console.log 'initialize CommentCollection: ', options
			@event_id = options.event_id
			@url = 'events/' + @event_id + "/comments"
			#console.log 'modified comment-files url: ', @url
			@


	class Venue extends Backbone.Model
		url: '/venues'

		initialize:(options) ->
			console.log 'initializing venues'


	window.App =
		"AppRouter": MainRouter
		"vent": _.extend({}, Backbone.Events)
		#'VenmoUser': User



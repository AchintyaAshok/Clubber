jQuery ->

	class MainRouter extends Backbone.Router
		routes:
			'' : 'home'


		# Basically a constructor for the AppRouter, this method retrieves the collection
		# of all events (without any filters) and the list of categories. 
		initialize: ->
			@currentView = null
			# window.App.VenmoUser = new User
			# window.App.vent.bind('table-selection', @table_view)


		show_view:(newView) =>
			if @currentView is not null then @currentView.close()
			@currentView = newView
			$('#container-main').html @currentView.render().el


		home: ->
			view = new Home
			view.fetch_information()
			#@navigate('/index')
			@show_view(view)


	class Home extends Backbone.View
		tagName: 'div'
		className: 'container-fluid'

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
			template = """
				<div class="row jumbotron">
					<h1>Welcome to your night.</h1>
					<p class="lead">Discover night-life events that are happening around you now.</p>
				</div>
			"""
			$(@el).html(_.template(template))
			eventViewItems = []
			for elem in @events.models
				newView = new HomePageEventView
					model: elem
				eventViewItems.push newView #add it to our list of managed event views
				$(@el).append(newView.render().el)
				$(@el).append('''<div class='row padding'><br></div>''')
				#console.log newView.render().el

			#console.log 'list of views managed: ', eventViewItems
			@	# last statement returns this

		close: ->
			@remove()


	class EventPageView
		model: Event

		initialize:(options) ->
			@model = options.model

		fetch_media: =>
			@mediaObjects = new MediaCollection
				event_id: @id
			@mediaObjects.fetch
				async: true
				success:(eve) ->
					return @
				error:(res) ->
					console.log 'Did not fetch Media Files: ', res

		fetch_comments: =>
			@comments = new CommentCollection
				event_id: @id
			@comments.fetch
				async: true 
				success:(e) ->
					return @
				error:(e) ->
					console.log 'Did not fetch Comments: ', e

		render: ->
			@fetch_media()
			@fetch_comments()



	class HomePageEventView extends Backbone.View

		tagName: 'div'
		className: 'row' # one row with 2 columns, one with text, one with a picture

		initialize:(options) =>
			#console.log 'initialize eventView: ', options
			@model = options.model
			@listenTo(this.model, "change", this.render) #when the model is modified, we update the view

		render: ->
			#console.log 'in eventView render', @model.toJSON()
			template = '''
				<div class='col-md-7'>
					<h2 class="featurette-heading"><%= name %></h2>
					<h4>
						<span class="text-muted"><b>at</b> Some Venue</span>
					</h4>
					<p class="lead"><%= description %></p>
					<p>
					  	<button type="button" class="btn btn-info btn-lg" id='info'>Tell Me More &raquo</button>
					</p>
				</div>
				<div class='col-md-5'>
					<img src="holder.js/350x350">
				</div>
			'''
			$(@el).html(_.template(template, @model.toJSON()))
			@

		events:
			'click #info': 'info_button_click'

		info_button_click: ->
			console.log 'info button was clicked!'
			window.App.vent.trigger('event_information', @model.get('id')) 
			#inform the application via Backbone Events that we want more information!



	class Event extends Backbone.Model
		url: '/events'

		initialize:(options) ->
			#console.log 'intialized event: ', @id

	
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



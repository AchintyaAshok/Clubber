jQuery ->

	class MainRouter extends Backbone.Router
		routes:
			'' : 'home'
			'index': 'home'
			'more_info/:id': 'event_information_page' #TOFIX ASKS FOR ID


		# Basically a constructor for the AppRouter, this method retrieves the collection
		# of all events (without any filters) and the list of categories. 
		initialize: ->
			@currentView = null
			window.App.vent.bind('event_information', @event_information_page)


		show_view:(newView) =>
			if @currentView is not null then @currentView.close()
			@currentView = newView
			$('#container-main').html @currentView.render().el
			$('.carousel').carousel({interval:2000})


		home: ->
			view = new Home
			@navigate('index')
			view.fetch_information()
			#@navigate('/index')
			@show_view(view)

		event_information_page:(options) => #options requires a hash of {id, model(if it exists)}
			# route to more information for an event
			console.log 'in event_information_page', options
			if options.model?
				view = new EventPageView
					model: options.model
			else
				view = new EventPageView
					id: options
				options = {id: options}
			@navigate('more_info/' + options.id)
			@show_view(view)

	# MAIN HOMEPAGE VIEW
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
					return @
				error:(response) ->
					console.log 'Did not fetch events: ', response

		render: ->
			template = """
				<div class="row jumbotron">
					<h1>Welcome to Clubber.</h1>
					<p class="lead">Discover night-life events that are happening around you now.</p>
				</div>
			"""
			switchImagePos = true
			$(@el).html(_.template(template))
			@eventViewItems = []
			for elem in @events.models
				newView = new HomePageEventView
					model: elem
					switchImagePos: switchImagePos
				@eventViewItems.push newView #add it to our list of managed event views
				$(@el).append(newView.render().el)
				$(@el).append('''<div class='row padding'><br><hr><br></div>''')
				if switchImagePos then switchImagePos = false
				else switchImagePos = true
			@	# last statement returns this

		close: ->
			x.remove() for x in @eventViewItems #remove all the child views
			@remove()

	# Sub-view of Home View
	class HomePageEventView extends Backbone.View

		tagName: 'div'
		className: 'row mini-event' # one row with 2 columns, one with text, one with a picture

		initialize:(options) =>
			#console.log 'initialize eventView: ', options
			@model = options.model
			@switchPosition = options.switchImagePos
			@listenTo(this.model, "change", this.render) #when the model is modified, we update the view

		render: ->
			#console.log 'in eventView render', @model.toJSON()
			headingDescTemplate = '''
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
			'''
			imageItemTemplate = '''
			<div class='col-md-5'>
				<img src="holder.js/350x350">
			</div>
			'''
			
			template = ''
			# just some fance position switching between the text and event image
			if @switchPosition 
				#console.log 'switchPosition=true'
				template += imageItemTemplate
				template += headingDescTemplate
			else
				#console.log 'switchPosition=false'
				template += headingDescTemplate
				template += imageItemTemplate

			$(@el).html(_.template(template, @model.toJSON()))
			@

		events:
			'click #info': 'info_button_click'

		info_button_click: ->
			console.log 'info button was clicked!', @model.get('id')
			window.App.vent.trigger('event_information', {id: @model.get('id'), model: @model}) 
			#inform the application via Backbone Events that we want more information!


	# PAGE TO VIEW MORE INFORMATION FOR EVENTS
	class EventPageView extends Backbone.View

		tagName: 'div'
		className: 'container-fluid'

		initialize:(options) ->
			console.log 'in EventPageView', options
			if options.model is undefined
				@model = new Event
					id: options.id
				@model.fetch
					async: false
					success:(e) ->
					error:(e) ->
						console.log 'EventPageView::init, Did not fetch Event', e
			else
				@model = options.model

		fetch_media: =>
			@mediaObjects = new MediaCollection
				event_id: @model.get('id')
			@mediaObjects.fetch
				async: false
				success:(eve) ->
					return @
				error:(res) ->
					console.log 'EventPageView::fetch_media, Did not fetch Media Files: ', res

		fetch_comments: =>
			@comments = new CommentCollection
				event_id: @model.get('id')
			@comments.fetch
				async: false 
				success:(e) ->
					return @
				error:(e) ->
					console.log 'EventPageView::fetch_comments, Did not fetch Comments: ', e

		fetch_venue: =>
			@venue = new Venue
				id: @model.get('venue_id')
			@venue.fetch
				async: false
				success:(e) ->
				error:(e) ->
					console.log 'EventPageView::fetch_venue, Did not fetch venue', e

		render: =>
			@fetch_media()
			@fetch_comments()
			@fetch_venue()
			console.log 'in render, fetched venue', @venue

			template = '''
			<div class='page-header'>
				<h1><%= name %> <small> <em>presented by </em>'''
			# add the name of the venue
			venueNameAddition = 
				'''<strong><%= venue_name %></strong></small></h1>
			</div>'''
			venueNameAddition = _.template(venueNameAddition, {venue_name: @venue.get('name')})
			template += venueNameAddition

			# if @mediaObjects.length > 0
			# 	template += @generate_carousel()

			template += '''
			</div class='row'>
				<div class='col-md-8'>
					<div class='row'>
						<div class='col-md-12'>
							<span>
								<h3>About this event...</h3>
								<p class='lead'><%= description %></p>
							</span>
						</div>
					</div>
				</div>'''

			template += @generate_comment_template()
			template += '''
			</div><!-- end row -->
			'''

			$(@el).html(_.template(template, @model.toJSON()))
			@

		generate_comment_template: =>
			#console.log 'generate_comment_template', @comments.toJSON()
			template = 
			'''<div class='col-md-4'>
					<div class='row'>
						<div class='col-md-12'>
							<span>
								<h3>The Buzz</h3>
								<p class='small muted'><i>Here's what people are saying...</i></p>
							</span>
						</div>
					</div>
			'''
			template += '''
			<% for(var i=0; i<comments.length; i++){ %>
				<div class="row">
					<div class='col-md-12'>
					    <a class="thumbnail">
					      <p><%= comments[i].text %></p>
					    </a>
				    </div>
				</div>
			<% } %>'''
			template += 
			'''</div><!-- end main container for comments -->'''
			options = {comments: @comments.toJSON()}
			#console.log options
			template = _.template(template, {comments: @comments.toJSON()})
			#console.log 'comment template', template
			return template

		generate_carousel: =>
			console.log "generating carousel", @mediaObjects.toJSON()
			template = '''
			<% if (models.length > 0){ %>
			<div id="myCarousel" class="carousel slide">
				<ol class="carousel-indicators">
				<% for(var i=0; i<models.length; i++){ %>
					<li data-target="#myCarousel" data-slide-to="<%= i %>"></li>
				<% } %>
				</ol>
				<div class="carousel-inner" style="height:600px; width:100%">
				<% for(var i=0; i<models.length; i++){ %>
					<div class="item">
						<img class='image-responsive' style="margin:0 auto;" src="<%= models[i].location %>" alt="">
					</div>
				<% } %>
				</div>
				<a class="carousel-control left" href="#myCarousel" data-slide="prev">&lsaquo;</a>
				<a class="carousel-control right" href="#myCarousel" data-slide="next">&rsaquo;</a>
			</div>
			<% } %>'''
			return _.template(template, {models: @mediaObjects.toJSON()})

			# template = '''
			# <div id="myCarousel" class="carousel slide" style="height:500px;" data-ride="carousel">
			#       <div class="carousel-inner">'''

			# for item in @mediaObjects.models
			# 	template += '''
			# 		<div class="item">
			# 		  <img src="<%= location %>">
			# 		</div>
			# 	'''
			# 	template = _.template(template, item.toJSON())

			# template += '''
			#       </div><!-- end carousel-inner -->
			#       '''
			# if @mediaObjects.length > 1
			# 	template += '''
			#       <a class="left carousel-control" href="#myCarousel" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span></a>
			#       <a class="right carousel-control" href="#myCarousel" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span></a>
			#       '''

			# template += '''
			#     </div><!-- /.carousel -->'''

			return template

		close: ->
			@remove()


	class Event extends Backbone.Model
		urlRoot: '/events'

		initialize:(options) ->
			if options? then @id = options.id
			console.log 'fetching event', @id

	
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
		urlRoot: '/venues'

		initialize:(options) ->
			console.log 'initializing venues'
			if options? and options.id?
				@id = options.id
				# fetch the venue pertaining to this venue



	window.App =
		"BackboneRouter": MainRouter
		"vent": _.extend({}, Backbone.Events)
		#'VenmoUser': User



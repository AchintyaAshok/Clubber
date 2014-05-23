jQuery ->

	class MainRouter extends Backbone.Router
		routes:
			'' : 'home'
			'home': 'home'
			'home/more_info/:id': 'event_information_page' #TOFIX ASKS FOR ID


		# Basically a constructor for the AppRouter, this method retrieves the collection
		# of all events (without any filters) and the list of categories. 
		initialize: ->
			@currentView = null
			window.App.vent.bind('event_information', @event_information_page)


		show_view:(newView) =>
			if @currentView is not null then @currentView.close()
			@currentView = newView
			$('#container-main').html @currentView.render().el


		home: ->
			view = new Home
			@navigate('home')
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
					id: options.id
			@navigate('home/more_info/' + options.id)
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
					<h1>Welcome to your night.</h1>
					<p class="lead">Discover night-life events that are happening around you now.</p>
				</div>
			"""
			$(@el).html(_.template(template))
			@eventViewItems = []
			for elem in @events.models
				newView = new HomePageEventView
					model: elem
				@eventViewItems.push newView #add it to our list of managed event views
				$(@el).append(newView.render().el)
				$(@el).append('''<div class='row padding'><br></div>''')

			@	# last statement returns this

		close: ->
			x.remove() for x in @eventViewItems #remove all the child views
			@remove()


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
						console.log 'EventPageView::Did not fetch Event', e
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
					console.log 'Did not fetch Media Files: ', res

		fetch_comments: =>
			@comments = new CommentCollection
				event_id: @model.get('id')
			@comments.fetch
				async: false 
				success:(e) ->
					return @
				error:(e) ->
					console.log 'Did not fetch Comments: ', e

		render: =>
			@fetch_media()
			@fetch_comments()
			console.log 'fetched stuff', @
			template = '''
			<div class='row'>
				<h1><%= name %> <small> presented by <strong>Some Venue</strong></small></h1>
			</div>
			<div id="myCarousel" class="carousel slide" style="height:500px;" data-ride="carousel">
			      <!-- Indicators -->
			      <ol class="carousel-indicators">
			        <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
			        <li data-target="#myCarousel" data-slide-to="1"></li>
			        <li data-target="#myCarousel" data-slide-to="2"></li>
			      </ol>
			      <div class="carousel-inner">
			        <div class="item active">
			          <img data-src="holder.js/900x500/auto/#777:#7a7a7a/text:First slide" alt="First slide">
			          <div class="container">
			            <div class="carousel-caption">
			              <h1>Example headline.</h1>
			              <p>Note: If you're viewing this page via a <code>file://</code> URL, the "next" and "previous" Glyphicon buttons on the left and right might not load/display properly due to web browser security rules.</p>
			              <p><a class="btn btn-lg btn-primary" href="#" role="button">Sign up today</a></p>
			            </div>
			          </div>
			        </div>
			        <div class="item">
			          <img data-src="holder.js/900x500/auto/#666:#6a6a6a/text:Second slide" alt="Second slide">
			          <div class="container">
			            <div class="carousel-caption">
			              <h1>Another example headline.</h1>
			              <p>Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
			              <p><a class="btn btn-lg btn-primary" href="#" role="button">Learn more</a></p>
			            </div>
			          </div>
			        </div>
			        <div class="item">
			          <img data-src="holder.js/900x500/auto/#555:#5a5a5a/text:Third slide" alt="Third slide">
			          <div class="container">
			            <div class="carousel-caption">
			              <h1>One more for good measure.</h1>
			              <p>Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
			              <p><a class="btn btn-lg btn-primary" href="#" role="button">Browse gallery</a></p>
			            </div>
			          </div>
			        </div>
			      </div>
			      <a class="left carousel-control" href="#myCarousel" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span></a>
			      <a class="right carousel-control" href="#myCarousel" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span></a>
			    </div><!-- /.carousel -->

			</div class='row'>
				<div class='col-md-8'>
					<p class='lead'>Description Goes Here</p>
				<div>
				<div class='col-md-4'>
					<p class='lead'>Comment Feed</p>
				</div>
			</div>
			'''
			$(@el).html(_.template(template, @model.toJSON()))
			@

		close: ->
			@remove()



	class HomePageEventView extends Backbone.View

		tagName: 'div'
		className: 'row mini-event' # one row with 2 columns, one with text, one with a picture

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
			console.log 'info button was clicked!', @model.get('id')
			window.App.vent.trigger('event_information', {id: @model.get('id'), model: @model}) 
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
		"BackboneRouter": MainRouter
		"vent": _.extend({}, Backbone.Events)
		#'VenmoUser': User



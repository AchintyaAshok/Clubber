`//= require javascripts/comments.js.coffee`

jQuery ->

	define ["./comment"], ('com') ->

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
				if @currentView is not null then @currentView.close()
				@currentView = newView
				$('#container-main').html @currentView.render().el


			home: ->
				console.log 'in home!'
				view = new Home
				@show_view view

			# table_view: =>
			# 	console.log 'in table view'
			# 	@navigate('makeMyTable')
			# 	view = new TableView
			# 	@show_view(view)

			# menu_view:(id) =>
			# 	console.log('get_menu', id)
			# 	menuView = new MenuView
			# 		id: id
			# 	@navigate('select_items/' + id)
			# 	@show_view(menuView)


		class Home extends Backbone.View

			tagName: 'div'

			initialize: ->
				console.log "initialize backbone view -> Home"
				c = new com.Comment('Bob', '123123123')

			render: ->
				template = '''<h>WELCOME</h>'''
				$(@el).html(_.template(template))
				c.print_something()
				@	# last statement returns this

			close: ->
				@remove()


		window.App =
			"AppRouter": MainRouter
			"vent": _.extend({}, Backbone.Events)
			#'VenmoUser': User



# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

	class Comment extends Backbone.Model

		timeStamp: '1231231'
		poster: 'tom'

		initialize:(posterName, timestamp) ->
			console.log 'this is a comment object'
			@poster = posterName
			@timestamp = timestamp

		print_something: ->
			console.log 'Poster: ' + @poster + "\tTime: " + @timestamp
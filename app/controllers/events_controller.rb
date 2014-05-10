class EventsController < ApplicationController
	def index # GET /events
		@events = Event.all
		objectToRender = {}
		# @events.each do |item|
		# 	comments = item.comments
		# end
		render json: @events
	end

	def show # GET /events/[id]
		@event = Event.find(params[:id])
		render json: @event
	end

	def create
		# use this to create a new venue
	end	

	# def getEventComments(event_id)
	# 	#print "getting event -> ", event_id, "\n"
	# 	comments = Comment.where(:event_id => event_id)
	# 	inc = 0
	# 	comments.each do |c|
	# 		print "\n\t", inc, ": [", c.text, "]\n"
	# 		inc += 1
	# 	end
	# 	if inc == 0
	# 		print "\n\tNO COMMENTS\n"
	# 	end

	# 	comments 	#return the list of comments
	# end

end

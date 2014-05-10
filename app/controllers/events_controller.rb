class EventsController < ApplicationController
	def index # GET /events
		@events = Event.all		
		@events.each do |item|
			# get all the comments for the event, return this
			print item.name
			comments = getEventComments item.id
		end
		#@events = @events.includes(:venue, :comments).all
		render json: @events
	end

	def show # GET /events/[id]
		@event = Event.find(params[:id])
		render json: @event
	end

	def create
		# use this to create a new venue
	end	

	def getEventComments(event_id)
		#print "getting event -> ", event_id, "\n"
		comments = Comment.where(:event_id => event_id)
		inc = 0
		comments.each do |c|
			print "\n\t", inc, ": [", c.text, "]\n"
			inc += 1
		end
		if inc == 0
			print "\n\tNO COMMENTS\n"
		end

		comments 	#return the list of comments
	end

end

class EventsController < ApplicationController
	def index
		@events = Event.all		
		@events.each do |item|
			# get all the comments for the event, return this
			print item.name
			comments = getEventComments item.id
			#item << {:comments => comments}
			#item["comments"] => comments
		end
		@events = @events.includes(:venue, :comments).all
		render json: @events
	end

	def show
		@event = Event.find(params[:id])
		render json: @event
	end

	def create
		# use this to create a new venue
	end	


	def getEventComments(event_id)
		print "getting event -> ", event_id, "\n"
		comments = Comment.where(:event_id => event_id)
		comments.each do |c|
			puts c.text
		end

		comments
		#Comment.event_id
	end

end

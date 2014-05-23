class EventsController < ApplicationController
	# attr_accessor :mainImage
	def index # GET /events
		debug = false
		@events = Event.all
		@events.each do |item|
			@mainImage = item.media.first()
			@venueName = item.venue
			item.attributes[:mainImage] = @mainImage
			item.attributes[:venueName] = @venueName
			puts item
		end
		
		# if debug
		# 	@events.each do |item|
		# 		#test to see if we find any media
		# 		mediaFiles = item.media
		# 		puts mediaFiles
		# 		mediaFiles.each do |file|
		# 			print "\n\tName: ", file.name
		# 			print "\n\tPath: ", file.location
		# 			print "\n\tSize: ", file.size
		# 			puts
		# 		end
		# 	end
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

end

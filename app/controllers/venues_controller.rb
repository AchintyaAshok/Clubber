class VenuesController < ApplicationController
	
	def index
		@venues = Venue.all
		# respond_to do |format|
		# 	format.html
		# 	# /venues.json -- returns all venues in json format
		# 	format.json { render json: @venues }
		# end
		# just sends everything back in json format
		render json: @venues
	end

	def show
		@venue = Venue.find(params[:id])
		render json: @venue
	end

	def create
		# use this to create a new venue
	end

end

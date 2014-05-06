class VenuesController < ApplicationController
	
	def index
		venues = Venue.all
		JSON.encode(venues)
	end

	def show
		@venue = Venue.find(params[:id])
	end
end

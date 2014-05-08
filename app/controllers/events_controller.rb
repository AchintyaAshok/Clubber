class EventsController < ApplicationController
	def index
		@events = Event.all
		
		render json: @events
		#puts @events
	end

	def show
		@event = Event.find(params[:id])
		render json: @event
	end

	def create
		# use this to create a new venue
	end	
end

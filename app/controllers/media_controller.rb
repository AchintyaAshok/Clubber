class MediaController < ApplicationController
	
	def index
		if params[:event_id]
			eventMedia = Event.find(params[:event_id]).media
			render json: eventMedia, status: 200
		end
	end

end

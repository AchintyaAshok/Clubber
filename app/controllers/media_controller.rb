class MediaController < ApplicationController
	
	def index
		if params[:event_id]
			eventMedia = Event.find(params[:event_id]).media
			render json: eventMedia, status: 200
		end
	end

	# def show
	# 	puts params
	# 	if params[:event_id]
	# 		eventMedia = Media.where(event_id = params[:event_id], id = params[:id])
	# 		render json: eventMedia
	# 	end
	# end


end

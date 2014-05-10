class CommentsController < ApplicationController
	def index	# GET events/[event_id]/comments
		# get all comments where the event id is listed
		comments = Comment.where(event_id = params[:id])
		render json: comments
	end

	def show	# GET events/[event_id]/comments/[id]
		# get a specific comment with a given id
		comment = Comment.find(params[:id])
		render json: comment
	end
end

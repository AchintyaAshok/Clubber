class Event < ActiveRecord::Base
	belongs_to :venue
	has_many :comments, dependent: :destroy
	# validates 
	# 	:name, presence: true, length: {minimum: 5},
	# 	:description, presence: true, length: {minimum: 5}
	# end
end

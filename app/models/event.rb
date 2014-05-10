class Event < ActiveRecord::Base
	belongs_to :venue
	has_many :comments, dependent: :destroy
	#event files
	has_many :event_files
	has_many :media, through: :event_files
end

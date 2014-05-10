class EventFile < ActiveRecord::Base
	belongs_to :event
	belongs_to :media
end

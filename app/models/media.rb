class Media < ActiveRecord::Base
	has_many :event_media
	has_many :events, through: :event_files
end

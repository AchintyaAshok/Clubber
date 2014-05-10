class Media < ActiveRecord::Base
	#eventfiles
	has_many :event_files
	has_many :events, through: :event_files
end

class Event < ActiveRecord::Base
	belongs_to :venue
	has_many :comments, dependent: :destroy
	has_many :media, through: :event_files
end

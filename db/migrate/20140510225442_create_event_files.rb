class CreateEventFiles < ActiveRecord::Migration
  def change
    create_table :event_files do |t|
    	t.belongs_to :event
    	t.belongs_to :media
      t.timestamps
    end
  end
end

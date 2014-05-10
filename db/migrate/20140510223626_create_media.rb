class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
    	t.string :name
    	t.string :location	# path to where the file is stored
    	t.integer :size		# calculate the size of the media file
      	t.timestamps
    end
  end
end

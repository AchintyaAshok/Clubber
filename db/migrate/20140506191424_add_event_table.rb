class AddEventTable < ActiveRecord::Migration
  def change
  	create_table :events do |t|

  		t.string :name
  		t.text :description
  		t.datetime :begins
  		t.datetime :ends

  		t.timestamps
  	end
  end
end

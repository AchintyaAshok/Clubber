class AddDetailsToVenue < ActiveRecord::Migration
  def change
  	add_column :venues, :name, :string
  	add_column :venues, :address, :string
  	add_column :venues, :description, :text
  end
end

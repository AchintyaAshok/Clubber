class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
    	t.belongs_to :event
    	t.text :text
      	t.timestamps
    end
  end
end

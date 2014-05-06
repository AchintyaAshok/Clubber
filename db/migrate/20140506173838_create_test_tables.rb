class CreateTestTables < ActiveRecord::Migration
  def change
    create_table :test_tables do |t|
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end

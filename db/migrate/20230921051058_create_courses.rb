class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.string :lecturer, null: false
      t.text :description, null: true

      t.timestamps
    end
  end
end

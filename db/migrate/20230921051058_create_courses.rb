class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :lecturer
      t.text :description

      t.timestamps
    end
  end
end

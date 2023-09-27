class CreateChapters < ActiveRecord::Migration[7.0]
  def change
    create_table :chapters do |t|
      t.string :name
      t.references :course, null: false, foreign_key: true
      t.integer :position, null: false

      t.timestamps
    end
  end
end

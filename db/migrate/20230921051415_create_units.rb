class CreateUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :units do |t|
      t.string :name, null: false
      t.text :description, null: true
      t.text :content, null: false
      t.references :chapter, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end

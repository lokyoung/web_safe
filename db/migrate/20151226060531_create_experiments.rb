class CreateExperiments < ActiveRecord::Migration
  def change
    create_table :experiments do |t|
      t.string :title
      t.text :description
      t.string :experimentfile
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

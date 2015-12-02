class AddReferenceBetweenHomeworkStuclass < ActiveRecord::Migration
  def change
    create_table :homeworks_stuclasses, id: false do |t|
      t.belongs_to :homework
      t.belongs_to :stuclass
    end
  end
end

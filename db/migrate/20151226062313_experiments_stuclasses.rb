class ExperimentsStuclasses < ActiveRecord::Migration
  def change
    create_table :experiments_stuclasses, id: false do |t|
      t.belongs_to :experiment
      t.belongs_to :stuclass
    end
  end
end

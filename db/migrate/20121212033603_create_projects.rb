class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.float :pledge_amount
      t.text :abstract

      t.timestamps
    end
  end
end

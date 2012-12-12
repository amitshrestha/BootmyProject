class AddNameToStudent < ActiveRecord::Migration
  def change
    add_column :students, :Name, :string
  end
end

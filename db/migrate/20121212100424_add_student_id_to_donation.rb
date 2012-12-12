class AddStudentIdToDonation < ActiveRecord::Migration
  def change
    add_column :donations, :student_id, :integer
  end
end

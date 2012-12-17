class AddCreditCardNoToStudent < ActiveRecord::Migration
  def change
    add_column :students, :credit_card_no, :decimal
  end
end

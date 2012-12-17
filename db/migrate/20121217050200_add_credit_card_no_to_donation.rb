class AddCreditCardNoToDonation < ActiveRecord::Migration
  def change
    add_column :donations, :credit_card_no, :decimal
  end
end

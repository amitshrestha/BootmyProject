class Donation < ActiveRecord::Base
  attr_accessible :amount, :credit_card_no
  belongs_to :student
  belongs_to :project

  def self.donors(id)
  	Donation.where('project_id=?',id)
  end
  def self.received
  	Donation.sum('amount')
  end
end

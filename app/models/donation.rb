class Donation < ActiveRecord::Base
  attr_accessible :amount
  belongs_to :student
  belongs_to :project
end

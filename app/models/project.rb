class Project < ActiveRecord::Base
  attr_accessible :abstract, :description, :pledge_amount, :title
  
  validates :title, :presence => true, :length =>{:maximum => 30}
  validates :description, :presence => true
  validates :pledge_amount, :presence => true
  validates :abstract, :presence => true, :length => {:maximum => 40 }
  
  has_many :donations
  has_many :students, :through => :donations  
  belongs_to :student
end

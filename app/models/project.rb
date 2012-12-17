class Project < ActiveRecord::Base
  attr_accessible :abstract, :description, :pledge_amount, :title, :photo
  
  validates :title, :presence => true, :length =>{:maximum => 30}
  validates :description, :presence => true
  validates :pledge_amount, :presence => true
  validates :abstract, :presence => true, :length => {:maximum => 40 }
  validates :photo, :attachment_presence => true
 
  
  has_many :donations
  has_many :students, :through => :donations  
  belongs_to :student

   #paperclip
  has_attached_file :photo,
     :styles => {
       :thumb=> "100x100#",
       :small  => "700x700>"
       }
end

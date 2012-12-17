class Project < ActiveRecord::Base
  attr_accessible :abstract, :description, :pledge_amount, :title, :photo
  
  validates :title, :presence => true, :length =>{:maximum => 30}
  validates :description, :presence => true
  validates :pledge_amount, :presence => true
  #validates :photo, :attachment_presence => true
  #validates_with AttachmentPresenceValidator, :attributes => :photo
  validates_attachment_presence :photo

validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

 
  
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

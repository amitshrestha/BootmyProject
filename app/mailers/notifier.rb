class Notifier < ActionMailer::Base
  default from: "amitshrestha1431@gmail.com"
  
  def welcome(donor)
    @donor = donor
    mail( :to => donor.student.email,
          :subject => "Donation",
          :body => "Thank you! You have donated #{donor.amount}"
        )    
  end
  
end

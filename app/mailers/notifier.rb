class Notifier < ActionMailer::Base
  default from: "rojesh.shrestha@sproutify.com"
  
  def welcome(recipient)
    @account = recipient
    mail(:to => recipient.email_address_with_name)    
  end
  
end

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :authentication       => "plain",
  :user_name            => "rojace2011@gmail.com",
  :password             => "captainjack535",    
  :enable_starttls_auto => true
}
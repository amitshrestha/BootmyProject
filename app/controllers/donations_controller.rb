class DonationsController < ApplicationController
   before_filter :authenticate_student!, :except =>[:show]


  def index
  	@donations = Donation.all
  end

  def new
  	@donation = Donation.new
  end

  def create
  end

  def show
  end
end

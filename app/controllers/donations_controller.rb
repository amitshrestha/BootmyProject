class DonationsController < ApplicationController
   before_filter :authenticate_student!, :except =>[:show]


  def index
  	@donations = Donation.all
  end

  def new
    @project = Project.find(params[:project_id])
  	@donation = Donation.new

  end

  def create
    @project = Project.find(params[:project_id])
    @donation = Donation.new(params[:donation])
    @donation.student_id = current_student.id
    @donation.project_id = @project.id
    if @donation.save
      Notifier.welcome(@donation).deliver!
    end
    redirect_to project_donation_path(@project.id,@donation.id)
  end

  def show
    @project = Project.find(params[:project_id])
    @donation = Donation.find(params[:id])
  end
end
 
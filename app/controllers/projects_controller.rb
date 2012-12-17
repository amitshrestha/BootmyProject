class ProjectsController < ApplicationController
  before_filter :authenticate_student!, :except =>[:show,:index]

  def index
    
    if current_student
      student_id = current_student.id
    end 
    
    @projects = Project.includes(:student).page(params[:page]).per(3)
  
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.create(params[:project])
    @project.student_id = current_student.id
    if @project.save
       redirect_to projects_path
    else 
        render 'new'
  end
  end

  def show
    @project = Project.find(params[:id])
    @donation = Donation.all
    @donor = Donation.donors(@project.id)
    @received = @donor.received
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_path
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
     @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
    redirect_to projects_path
    else
    render "new"
    end
  end

  def donate
        @project = Project.find(params[:id])

  end
end

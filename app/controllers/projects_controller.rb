class ProjectsController < ApplicationController
  before_filter :authenticate_student!, :except =>[:show,:index]

  def index
    if current_student
      student_id = current_student.id
      @projects = Project.where(:student_id => student_id)
    else
      @projects = Project.includes(:student).all
    end
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.create(params[:project])
    @project.student_id = current_student.id
    @project.save!
    redirect_to projects_path
  end

  def show
    @project = Project.find(params[:id])
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

class VisitsController < ApplicationController
  before_action :authorize
  def index
    @visits = Visit.all
  end

  def new
    @visit = Visit.new
  end

  def show
    @visit= Visit.find params[:id]
  end

  def edit
    @visit = Visit.find params[:id]
    unless @current_user.visits.include? @visit
      redirect_to root_path
    else
      render :edit
    end
  end

  def update
    visit = Visit.find params[:id]
    unless @current_user.visits.include? visit
      redirect_to root_path, alert: 'Not authorized'
      return
    end
    visit.update visit_params
    redirect_to visit
  end

  def create
    visit = current_user.visits.build visit_params
    if visit.save
      flash[:success] =  "Visit Created!"
      redirect_to visit
    else
      render :new
    end
  end



  def destroy
    visit = Visit.find params[:id]
    visit.destroy if @current_user.visits.include? visit
    flash[:success] =  "Visit has been Deleted!"
    redirect_to visits_path
  end

  # Strong params: create a whitelist of permitted parameters
private
def visit_params
  params.require(:visit).permit(:start_date, :end_date, :location, :latitude, :longitude)
end
end
#  start_date :date
#  end_date   :date
#  location   :text
#  latitude   :float
#  longtitude :float

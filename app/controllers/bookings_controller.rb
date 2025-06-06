class BookingsController < ApplicationController
  before_action :authorize
  def index
  end

  def show
    @booking = Booking.find params[:id]
  end

  def edit
  end

  def create
    artist_id = booking_params[:artist_id]
    date = booking_params[:date]
    start_hour = booking_params[:start_hour]
    if Booking.exists?(artist_id: artist_id, date: date, start_hour: start_hour)
      flash[:error] = 'Artist is already booked for that time.'
      redirect_back fallback_location: root_path
      return
    end
    @booking = Booking.new(booking_params)
    @booking.customer_id = @current_user.id
    if @booking.save
      redirect_to @booking
    else
      render :new
    end
  end

  def new
    # Make sure that the visit_id that the user sent, actually exists
    @visit = Visit.find params[:visit_id]

    # Build an array of dates to present to the user
    @dateRange = (@visit.start_date..@visit.end_date).to_a

    @booking = Booking.new
  end

  def destroy
  end

  def update
  end

  private

  def booking_params
    params.require(:booking).permit(:artist_id, :date, :start_hour)
  end
end

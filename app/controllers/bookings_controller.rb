class BookingsController < ApplicationController
  def index
  end

  def show
    @booking = Booking.find params[:id]
  end

  def edit
  end

  def create
  end

  def new
  end

  def destroy
  end

  def update
  end
end

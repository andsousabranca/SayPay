class TripsController < ApplicationController

  def index
    @trips = Trip.all
    @trips.count > 0 ? @title = "Trips List:" : @title = "You have no trips yet."
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user_id = 2

    if @trip.save
      redirect_to trips_path
    else
      render "new", status: :unprocessable_content
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:country, :budget)
  end
end

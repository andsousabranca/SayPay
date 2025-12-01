class TripsController < ApplicationController

  def index
    @trips = Trip.all
    @trips.count > 0 ? @title = "Trips" : @title = "Create a trip and start logging expenses!"
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user_id = current_user.id

    if @trip.save
      # redirect_to trips_path
      redirect_to  new_trip_expense_path(@trip)
    else
      render "new", status: :unprocessable_content
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:country, :budget)
  end
end

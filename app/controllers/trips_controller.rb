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

  # When Devise will be active
  # @trip.user_id = current_user.id
  if User.exists?(id: 8)
    @trip.user_id = 8
  else
    puts "User id does not exist"
    raise
  end

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

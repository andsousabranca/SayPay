class TripsController < ApplicationController

  def index
    @trips = Trip.all
    @trips = Trip.order(created_at: :desc)
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user_id = current_user.id

    # Unsplash Image fetch
    @trip.url = UnsplashService.new("#{@trip.country}").call.first.urls.raw

    if @trip.save
      # redirect_to trips_path
      redirect_to  new_trip_expense_path(@trip)
    else
      render "new", status: :unprocessable_content
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:country, :budget, :start_date, :end_date)
  end
end

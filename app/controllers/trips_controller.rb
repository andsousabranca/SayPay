class TripsController < ApplicationController

  def index
    @trips = Trip.all.where(user: current_user).order(created_at: :desc)
  end

  def new
    @trip = Trip.new
    @user = current_user
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user_id = current_user.id

    # Unsplash Image fetch
    initial_image_url = UnsplashService.new("#{@trip.country}").call.first.urls.raw

    # reduce the quality of the picture
    @trip.url = "#{initial_image_url}&q=10"

    if @trip.save
      redirect_to new_trip_expense_path(@trip)
    else
      render "new", status: :unprocessable_content
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:country, :budget, :budget_currency, :start_date, :end_date)
  end
end

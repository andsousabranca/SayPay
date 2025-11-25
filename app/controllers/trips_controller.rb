class TripsController < ApplicationController

  def index
    @trips = Trip.all
    @trips.count > 0 ? @title = "Trips List:" : @title = "You have no trips yet."
  end

  def new
    @trip = Trip.new

  end

end

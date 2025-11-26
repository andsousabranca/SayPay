class ExpensesController < ApplicationController
  def index
  end

  def new
    @expense = Expense.new
    @recording = Recording.new
    @trip = Trip.find(params[:trip_id])
  end

  def create

  end

end

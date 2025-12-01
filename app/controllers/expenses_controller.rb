class ExpensesController < ApplicationController

  def index
    @expenses = Expense.all
    @trips = Trip.all
    @summary = summarize_exp
  end

  def new
    @expense = Expense.new
    @trip = Trip.find(params[:trip_id])
  end

  def create
    @expense = Expense.new(expense_params.except(:audio))

    if expense_params[:audio].present?
      @expense.audio.attach(expense_params[:audio])
    end

    if @expense.save
      # enqueue audio processing asynchronously
      ProcessExpenseAudioJob.perform_now(@expense.id) if @expense.audio.attached?
      redirect_to edit_trip_expense_path(trip: @expense.trip, id: @expense), notice: "Recording uploaded successfully."
    else
      @expense.audio.purge if @expense.audio.attached?
      flash.now[:alert] = @expense.errors.full_messages.to_sentence
      render "expenses/new", status: :unprocessable_entity
    end
  end

  def edit
    @expense = Expense.find(params[:id])
    @trip = @expense.trip
  end

  def update
    @expense = Expense.find(params[:id])
    @trip = @expense.trip

    if @expense.update(expense_params.except(:audio))
      redirect_to new_trip_expense_path(@trip), notice: "Expense updated successfully."
    else
      flash.now[:alert] = @expense.errors.full_messages.to_sentence
      render "expenses/edit", status: :unprocessable_entity
    end
  end

  private

  def summarize_exp
    # Replace with current user!

    @user = current_user.id

    remaining = 0

    @trips.each do |trip|
      remaining += trip.budget
    end

    # remaining = @user.trips[0].budget
    spent = 0
    count = 0
    @expenses.each do |expense|
      spent += expense.base_amount.fractional
      count += 1
    end
    remaining -= (spent/100)
    return (spent/100), remaining, count
  end

  def expense_params
    params.require(:expense).permit(:trip_id, :audio, :local_amount, :local_amount_currency, :category)
  end
end

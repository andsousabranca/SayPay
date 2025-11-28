class ExpensesController < ApplicationController

  def index
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

  def expense_params
    params.require(:expense).permit(:trip_id, :audio, :local_amount, :local_amount_currency, :category)
  end
end

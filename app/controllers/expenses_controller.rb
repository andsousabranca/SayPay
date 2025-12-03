class ExpensesController < ApplicationController

  def index

    if params[:country].present?
      @trips = Trip.where(user: current_user, country: params[:country])
      @expenses = Expense.where(user: current_user, trip: @trips)

      # Expenses Pie Chart
      @expenses_by_category = @expenses.group(:category).sum("base_amount_cents / 100.0")

      # Category Column Chart
      @amount_by_category = @expenses.group(:category).count

      # Spending per country line chart
      @spending_per_country = @trips.joins(:expenses).group(:country).sum("expenses.base_amount_cents / 100.0")

      # Aggregate spending by day
      @spending_over_time = @expenses.group_by_day(:created_at).sum("base_amount_cents / 100.0").transform_keys do |date|
        date.strftime("%d %B")
      end

    else
      @expenses = Expense.all.where(user: current_user, )
      @trips = Trip.all.where(user: current_user)

      # Expenses Pie Chart
      @expenses_by_category = @expenses.group(:category).sum("base_amount_cents / 100.0")

      # Category Column Chart
      @amount_by_category = @expenses.group(:category).count

      # Spending per country line chart
      @spending_per_country = @trips.joins(:expenses).group(:country).sum("expenses.base_amount_cents / 100.0")

      # Aggregate spending by day
      @spending_over_time = @expenses.group_by_day(:created_at).sum("base_amount_cents / 100.0").transform_keys do |date|
        date.strftime("%d %B")
      end
    end

    @filter = Trip.all.where(user: current_user)
    @summary = summarize_exp
  end

  def new
    @expense = Expense.new
    @trip = Trip.find(params[:trip_id])

    raise
    @trips = Trip.all.where(user: current_user)
    @expenses = Expense.all.where(user: current_user)
    @summary = summarize_exp

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
      @expense.calculate_base_amount
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
      remaining += trip.budget.fractional
    end


    spent = 0
    count = 0
    @expenses.each do |expense|
      spent += expense.base_amount.fractional
      count += 1
    end

    remaining -= spent

    remaining_money = Money.new(remaining, current_user.base_currency)
    spent_money = Money.new(spent, current_user.base_currency)

    return spent_money, remaining_money, count
  end

  def expense_params
    params.require(:expense).permit(:trip_id, :audio, :local_amount, :local_amount_currency, :category)
  end
end

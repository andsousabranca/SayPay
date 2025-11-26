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
      redirect_to new_trip_expense_path(trip_id: @expense.trip_id), notice: "Recording uploaded successfully."
    else
      @expense.audio.purge if @expense.audio.attached?
      flash.now[:alert] = @expense.errors.full_messages.to_sentence
      render "expenses/new", status: :unprocessable_entity
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:trip_id, :audio)
  end

  # def process_file
  #   ruby_llm_chat = RubyLLM.chat(model: "gpt-4o-audio-preview") # audio-capable model
  #   prompt = "Could you describe the content in this audio file?"
  #   ruby_llm_chat.with_instructions(SYSTEM_PROMPT)
  #   response = ruby_llm_chat.ask(prompt, with: {audio: @expense.audio})
  #   puts response.content
  #   puts "Tokens used: #{response.input_tokens} input, #{response.output_tokens} output"
  # end
end

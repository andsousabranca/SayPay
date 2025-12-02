class ProcessExpenseAudioJob < ApplicationJob
  queue_as :default

  SYSTEM_PROMPT = <<~PROMPT
    You are an AI assistant that extracts structured expense information from a given transcription of an audio recording.
    You are provided with:
    - A text transcription of what the user said.
    Your task is ONLY to extract information, not to transcribe.

    Extract the following fields:
    1. local_amount
      Return the amount as an integer in minor units (subunits), following the rules below:
        Multiply by 100
        Example:
          “45 EUR” → 4500
          “12.30 USD” → 1230
          “1,000 yen” → 100000
          “10 rupiah” → 1000
      Important:
        If the amount is missing or unclear, return null.
    2. local_currency
      Return the ISO currency code (e.g., EUR, USD, JPY, IDR)
      If missing or unclear, return null.
    3. category
      Select ONE from the following:
        "Meals",
        "Drinks & Nightlife",
        "Local Transport",
        "Flights & Long-haul Transport",
        "Car (rental/fuel/parking/tolls)",
        "Accommodation",
        "Activities & Tours",
        "Communication & Connectivity",
        "Travel Docs & Insurance",
        "Health & Safety",
        "Shopping & Supplies",
        "Fees & Banking",
        "Tips & Gratuities",
        "Other"
      If unclear, return null.
    4. notes
      Provide a short description of the expense.
      If not available, return null.

  Output format:
  Return JSON only, in this exact structure:
    {
      "local_amount": 4500,
      "local_currency": "EUR",
      "category": "Meals",
      "notes": "Dinner at local restaurant"
    }
  PROMPT

  TRANSCRIPTION_PROMPT = <<~PROMPT
    You are an AI assistant that helps users by transcribing and summarizing audio recordings related to their expenses during trips.
    When given an audio file, you will transcribe the content accurately.
    Provide only the transcription text as the response.
  PROMPT

  def perform(expense_id)
    expense = Expense.find(expense_id)
    return unless expense&.audio&.attached?
    
    blob = expense.audio.blob

    blob.open(tmpdir: Dir.tmpdir) do |tempfile|
      tempfile.binmode
      tempfile.rewind

      transcription = nil

      transcription = RubyLLM.transcribe(
        tempfile.path,
        model: "gpt-4o-mini-transcribe",
        prompt: TRANSCRIPTION_PROMPT,
        provider: :openai)

      # transcription = "Had a burger for 12 EUR at a local diner."

      expense.update!(audio_transcript: transcription.text) # add text

      @ruby_llm_chat = RubyLLM.context do |config|
        config.openai_api_key = ENV['GITHUB_TOKEN']
        config.openai_api_base = "https://models.inference.ai.azure.com"
      end

      # # Create expense record as JSON with transcription
      ruby_llm_chat = @ruby_llm_chat.chat
      ruby_llm_chat.with_instructions(SYSTEM_PROMPT)
        
      # extraction of audio details
      response = ruby_llm_chat.ask("Please extract expense details from this transcribed text: #{transcription.text}") # add text

      parsed = JSON.parse(response.content) rescue nil
      if parsed.present?
        expense.update(
          local_amount_cents: parsed["local_amount"],
          local_amount_currency: parsed["local_currency"] || "USD",
          category: parsed["category"],
          notes: parsed["notes"]
        )
      else
        Rails.logger.warn "LLM parsing returned invalid JSON: #{response.content.inspect}"
      end
    end
  end
end
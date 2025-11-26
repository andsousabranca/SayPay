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
      A. For currencies with 2 decimal places
        (EUR, USD, GBP, AUD, CAD, CHF, etc.)
        Multiply by 100
        Example:
          “45 EUR” → 4500
          “12.30 USD” → 1230
      B. For currencies with 0 decimal places
        (JPY, IDR, KRW, VND, XOF, KHR, etc.)
        Do NOT multiply
        The subunit is the same as the unit
        Example:
          “1,000 yen” → 1000
          “10 rupiah” → 10
      Important:
        If unsure about the currency's decimal structure, assume 0 decimals and do not multiply. If the amount is missing or unclear, return null.
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

    # begin
      transcription = RubyLLM.transcribe(
        tempfile.path,
        model: "gpt-4o-mini-transcribe",
        prompt: TRANSCRIPTION_PROMPT,
        provider: :openai)
    # rescue StandardError => e
    #   Rails.logger.warn("Transcription failed: #{e.class}: #{e.message}")
    #   return
    # end

    expense.update!(audio_transcript: transcription.text)
    debugger

    # Create expense record as JSON with transcription
    ruby_llm_chat = RubyLLM.chat(provider: :gemini)
    ruby_llm_chat.with_instructions(SYSTEM_PROMPT)
      
    # extraction of audio details
    response = ruby_llm_chat.ask("Please extract expense details from this transcribed text: #{transcription.text}")
    debugger

    parsed = JSON.parse(response.content) rescue nil
    if parsed.present?
      expense.update!(
        local_amount: parsed["local_amount"],
        local_currency: parsed["local_currency"],
        category: parsed["category"],
        notes: parsed["notes"]
      )
    else
      Rails.logger.warn "LLM parsing returned invalid JSON: #{response.content.inspect}"
    end
  end
  # rescue => e
  #   Rails.logger.error("ProcessExpenseAudioJob failed for expense #{expense_id}: #{e.class} #{e.message}")
  end
end
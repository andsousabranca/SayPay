class CurrencyConversionJob < ApplicationJob
  queue_as :default

  def perform(user)
    conversion_rate = 1
    local_currency = user.local_amount_currency
    base_currency = user.base_amount_currency
    
    if (base_currency != local_currency)
      # Use service to get conversion rate
      conversion_rate = CurrencyConverter.call(local_amount_currency: local_currency, base_amount_currency: base_currency)
    end

    base_amount_cents = conversion_rate * user.local_amount_cents
    user.update(base_amount_cents: base_amount_cents)
  end
end

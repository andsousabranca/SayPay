class CurrencyConverter
  require 'net/http'
  require 'json'

  def self.call(args = {})
    # Setting URL
    url = "https://v6.exchangerate-api.com/v6/#{ENV["EXCHANGE_RATE_API"]}/latest/#{args[:local_amount_currency]}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    response_obj = JSON.parse(response)

    # Getting a rate
    rate = response_obj['conversion_rates'][args[:base_amount_currency]]
    return rate
  end
end
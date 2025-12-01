Unsplash.configure do |config|
  config.application_access_key = ENV["UNSPLASH_ACCESS_KEY"]
  config.application_secret = ENV["UNSPLASH_SECRET"]
  config.application_redirect_uri = "http://localhost:3000/oauth/callback"
  config.utm_source = "SayPay"

  # optional:
  # config.logger = MyCustomLogger.new
end

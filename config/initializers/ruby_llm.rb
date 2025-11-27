RubyLLM.configure do |config|
  if ENV['GITHUB_TOKEN'].present?
    # For Chatbot
    config.openai_api_key  = ENV['GITHUB_TOKEN']
    config.openai_api_base = "https://models.inference.ai.azure.com"
  elsif ENV['OPENAI_API_KEY'].present?
    # For voice record
    config.openai_api_key  = ENV['OPENAI_API_KEY']
  else
    raise "Missing both GITHUB_TOKEN and OPENAI_API_KEY"
  end

  config.use_new_acts_as = true
end

# Load the Rails application.
require File.expand_path('../application', __FILE__)

require 'd_logger'

WotcsRailsProof::Application.configure do
	config.log_formatter = Lograge::Formatters::Logstash.new
	config.lograge.enabled = true

	config.lograge.custom_options = lambda { |event| { time: event.time } }

	config.lograge.formatter = Lograge::Formatters::Logstash.new
	config.logger = DLogger.new(File.join(Rails.root, 'log', "#{Rails.env}.log"))
end

# Initialize the Rails application.
Rails.application.initialize!

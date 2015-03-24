class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	before_action :setup_locals

	protected

	def current_region
		@locals[:region]
	end

	private

	def setup_locals
		@locals = {}

		region = (params[:region] || cookies[:region] || 1).to_i
		region = 1 if Regions::SUPPORTED_REGIONS[region].nil?
		cookies[:region] = { value: region, expires: 1.year.from_now } if cookies[:region] != region
		@locals[:region] = region
	end
end

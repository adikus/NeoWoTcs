class SearchController < ApplicationController
	def index
		response = WargamingApi.new(current_region).clan_search(params[:search]).parsed_response
		if response['error'].present?
			@clans = []
			@locals[:error] = response['error']['message']
		else
			@clans = response['data']
		end
	end
end

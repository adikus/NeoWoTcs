class PlayerStatsUpdaterWorker
include Sidekiq::Worker

	sidekiq_options backtrace: true
	sidekiq_options throttle: { threshold: 5, period: 1.second, name: ->(region, _ids) {"api-#{region}"} }

	def perform(region, ids)
		return if region == 4
		#Rails.logger.info "Starting player accounts updater worker with ids #{ids}"

		response = WargamingApi.new(region).account_stats(ids)

		# Rails.logger.info response.code
		if response.parsed_response['data'].nil?
			Rails.logger.info response.parsed_response
			raise Exception.new(response.parsed_response['error']) if response.parsed_response['error']
		else
			players = Player.find(ids)
			ids.each do |id|
				player = players.detect { |p| p.id == id }
				player.update_stats(response.parsed_response['data'][id.to_s])
				#WebsocketRails["players.#{id}"].trigger 'update', response.parsed_response['data'][id.to_s]
			end
		end
	end
end

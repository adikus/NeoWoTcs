class ClanUpdaterWorker
	include Sidekiq::Worker

	sidekiq_options backtrace: true
	sidekiq_options throttle: { threshold: 5, period: 1.second, name: ->(region, _ids) {"api-#{region}"} }

	def perform(region, ids)
		return if region == 4
		Rails.logger.info "Starting clan updater worker with ids #{ids}"

		response = WargamingApi.new(region).clan_info(ids)

		Rails.logger.info response.code

		ids.each do |id|
			if response.parsed_response['data'].nil?
				Rails.logger.info response.parsed_response
				raise Exception.new(response.parsed_response['error']) if response.parsed_response['error']
			end
			unless response.parsed_response.andand['data'].andand[id.to_s].andand['members'].nil?
				WebsocketRails["clans.#{id}"].trigger 'update', response.parsed_response['data'][id.to_s]
				PlayerStatsUpdaterWorker.perform_async(region, response.parsed_response['data'][id.to_s]['members'].keys.map(&:to_i))
				PlayerTanksUpdaterWorker.perform_async(region, response.parsed_response['data'][id.to_s]['members'].keys.map(&:to_i))
			end
		end
	end
end

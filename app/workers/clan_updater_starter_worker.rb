class ClanUpdaterStarterWorker
	include Sidekiq::Worker

	sidekiq_options backtrace: true

	BATCH_SIZE = 100

	def perform
		batches = [[]]*6
		CSV.foreach('clans.csv') do |(id)|
			id = id.to_i
			region = Regions.from_id(id)
			batches[region] << id
			if batches[region].length >= BATCH_SIZE
				ClanUpdaterWorker.perform_async(region, batches[region])
				batches[region] = []
			end
		end
		batches.each_with_index do |ids, region|
			ClanUpdaterWorker.perform_async(region, ids) if ids.length > 0
		end
	end
end

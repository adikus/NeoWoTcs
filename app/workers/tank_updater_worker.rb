class TankUpdaterWorker
	include Sidekiq::Worker

	sidekiq_options backtrace: true

	def perform
		Rails.logger.info 'Updating tanks'

		response = WargamingApi.new(1).tankopedia

		Rails.logger.info response.code

		data = response['data']
		data.each do |id, row|
			player = Tank.find_or_create_by!(id: id)

			row['tank_type'] = row.delete('type')

			player.update!(row)
		end

		nil
	end
end

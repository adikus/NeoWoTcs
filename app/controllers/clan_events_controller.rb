class ClanEventsController < WebsocketRails::BaseController
  def load
		ClanUpdaterWorker.perform_async(1, [message.to_i])
  end
end

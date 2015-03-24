class PlayersController < ApplicationController

	before_action :load_player, only: [:show]

	def show
	end

	private

	def load_player
		@player = Player.find_or_create_by(id: params[:id])
	end
end

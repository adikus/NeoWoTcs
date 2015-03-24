class ClansController < ApplicationController

	before_action :load_clan, only: [:show, :stats, :members, :tanks, :changes]
	before_action :setup_clan_locals, except: :home

	def home
	end

  def index
		@clans = Clan.paginate(page: params[:page])
	end

	def show
		@member_view = ClanMemberView.new(@clan)
		@stat_view = ClanStatView.new(@clan)
		@tank_view = ClanTankView.new(@clan)
	end

	def stats
		@stat_view = ClanStatView.new(@clan)
	end

	def members
	end


	def tanks
	end


	def changes
	end

	private

	def load_clan
		@clan = Clan.find_or_load(params[:id].to_i, force_load: params[:force].present?)
		@locals[:title] = @clan.tag
	end

	def setup_clan_locals
		@locals[:nav_item] = :clans
	end
end

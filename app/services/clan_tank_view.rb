class ClanTankView
	TYPE_ORDER = {'heavy' =>0, 'medium' =>1, 'light' =>2, 'td' =>3, 'arty' =>4}

	def initialize(clan)
		@clan = clan

		@top_tank_table = @clan.player_tanks.joins(:tank).includes(:tank).merge(Tank.top).group_by{ |pt| pt.tank.tank_type }
		@top_tank_table['light'] = @clan.player_tanks.joins(:tank).includes(:tank).merge(Tank.top_scout)

		TYPE_ORDER.each do |type, _order|
			@top_tank_table[type] = [] if @top_tank_table[type].nil?
		end

		@top_tank_table = @top_tank_table.sort_by { |type, _tanks| TYPE_ORDER[type] }.to_h
	end

	def player_counts
		@top_tank_table.inject({}) do |memo, (type, tanks)|
			memo[type] = tanks.map(&:player_id).uniq.count
			memo
		end
	end

	def tank_counts
		@top_tank_table.inject({}) do |memo, (type, tanks)|
			memo[type] = tanks.count
			memo
		end
	end

	def count
		@top_tank_table.values.sum(&:size)
	end

end
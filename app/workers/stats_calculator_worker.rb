class StatsCalculatorWorker
	include Sidekiq::Worker

	sidekiq_options backtrace: true

	def perform(player_ids)
		players = Player.find player_ids
		players.each { |player| calculate_for(player) }
	end

	private

	def calculate_for(player)
		stats = player.current_stats
		player_tanks = player.player_tanks.includes(:tank).to_a
		stats.wn8 = wn8(stats, expected_values(player_tanks))
		stats.average_tier = player_tanks.sum { |pt| pt.tank.level * pt.battles }.to_f / player_tanks.sum(&:battles)
		stats.efficiency = efficiency(stats)

		stats.save!
	end

	def expected_values(player_tanks)
		expected = JSON.parse(File.read('expected_tank_values.json'))['data'].map {|row| [row['IDNum'], row] }.to_h

		player_tanks.inject({ frags: 0, damage: 0, spotted: 0, defense: 0, wins: 0 }) do |memo, player_tank|
			memo[:frags] += player_tank.battles * expected[player_tank.tank_id]['expFrag']
			memo[:damage] += player_tank.battles * expected[player_tank.tank_id]['expDamage']
			memo[:spotted] += player_tank.battles * expected[player_tank.tank_id]['expSpot']
			memo[:defense] += player_tank.battles * expected[player_tank.tank_id]['expDef']
			memo[:wins] += player_tank.battles * expected[player_tank.tank_id]['expWinRate'] / 100
			memo
		end
	end

	def wn8(stats, expected)
		r_damage = (stats.damage.to_f / stats.battles)  / (expected[:damage].to_f / stats.battles)
		r_spot   = (stats.spotted.to_f / stats.battles) / (expected[:spotted].to_f / stats.battles)
		r_frag   = (stats.frags.to_f / stats.battles)   / (expected[:frags].to_f / stats.battles)
		r_def    = (stats.defense.to_f / stats.battles) / (expected[:defense].to_f / stats.battles)
		r_win    = (stats.wins.to_f / stats.battles)    / (expected[:wins].to_f / stats.battles)
		r_win_c    = [0,                     (r_win    - 0.71) / (1 - 0.71) ].max
		r_damage_c = [0,                     (r_damage - 0.22) / (1 - 0.22) ].max
		r_frag_c   = [0, [r_damage_c + 0.2, (r_frag   - 0.12) / (1 - 0.12)].min].max
		r_spot_c   = [0, [r_damage_c + 0.1, (r_spot   - 0.38) / (1 - 0.38)].min].max
		r_def_c    = [0, [r_damage_c + 0.1, (r_def    - 0.10) / (1 - 0.10)].min].max
		980*r_damage_c + 210*r_damage_c*r_frag_c + 155*r_frag_c*r_spot_c + 75*r_def_c*r_frag_c + 145*[1.8,r_win_c].min
	end

	def efficiency(stats)
		f2 = stats.average_tier > 0 ? 10/(stats.average_tier+2)*(0.23+2*stats.average_tier/100) : 0
		efr  = stats.frags.to_f / stats.battles * 250
		efr += stats.damage.to_f / stats.battles * f2
		efr += stats.spotted.to_f / stats.battles * 150
		efr += Math.log(stats.capture.to_f / stats.battles + 1) / Math.log(1.732) * 150
		efr += stats.defense.to_f / stats.battles * 150

		efr
	end
end

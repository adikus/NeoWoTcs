class ClanStatView
	CLAN_AVERAGES = {
		min: {battles: 0, winrate: 46.8, damage: 350, wn8: 600, efficiency: 630},
		max: {battles: 24200, winrate: 60.8, damage: 1570, wn8: 2400, efficiency: 1590}
	}
	CLAN_OVERALLS = {
		min: {battles: 20000, winrate: 46.8, damage: 7000000, wn8: 2500, efficiency: 3000},
		max: {battles: 2500000, winrate: 60.8, damage: 3925000000, wn8: 220000, efficiency: 175000}
	}

	def initialize(clan)
		@clan = clan

		@current_player_stats = @clan.current_player_stats
	end

	def average_stats
		process_values do |battle_count|
			player_count = current_player_stats.count

			{
				battles: battle_count.to_f / player_count,
				winrate: current_player_stats.sum(&:wins).to_f / battle_count * 100,
				damage: current_player_stats.sum(&:damage).to_f / battle_count,
				wn8: current_player_stats.sum { |stat| stat.wn8 * stat.battles } / battle_count,
				efficiency: current_player_stats.sum { |stat| stat.efficiency * stat.battles } / battle_count
			}
		end
	end

	def overall_stats
		process_values(CLAN_OVERALLS) do |battle_count|
			{
				battles: battle_count,
				winrate: current_player_stats.sum(&:wins).to_f / battle_count * 100,
				damage: current_player_stats.sum(&:damage),
				wn8: current_player_stats.sum(&:wn8),
				efficiency: current_player_stats.sum(&:efficiency)
			}
		end
	end

	def player_stats
		@clan.members.map do |player|
			stats = current_player_stats.detect { |s| s.player.id == player.id }
			res = {
				id: player.id,
				name: player.name
			}
			res.merge!({
				battles: stats.battles,
				winrate: stats.wins.to_f / stats.battles * 100,
				damage: stats.damage.to_f / stats.battles,
				frags: stats.frags.to_f / stats.battles,
				wn8: stats.wn8,
				efficiency: stats.efficiency,
				created_at: stats.created_at
			}) if stats.present?
			res
		end.sort_by { |row| -(row[:wn8] || 0) }
	end

	def null_stats
		%i{battles winrate damage wn8 efficiency}.inject({}) do |memo, stat|
			memo[stat] = {value: 0, percentile: 0}
			memo
		end
	end

	private

	def process_values(percentile_data = CLAN_AVERAGES)
		battle_count = current_player_stats.sum(&:battles)
		return null_stats if battle_count == 0
		values = yield(battle_count)
		values.inject({}) do |memo, (stat, value)|
			memo[stat] = {
				percentile: (value.to_f - percentile_data[:min][stat]) / (percentile_data[:max][stat].to_f - percentile_data[:min][stat]) * 100,
				value: value
			}
			memo
		end
	end

	attr_accessor :current_player_stats
end
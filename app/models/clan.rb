class Clan < ActiveRecord::Base
	self.per_page = 20

	has_many :members, class_name: :Player
	has_many :player_tanks, through: :members
	has_many :tanks, through: :player_tanks
	has_many :player_stats, through: :members

	enum status: {
				 ok: 1
			 }

	def needs_update?
		Time.zone.now - updated_at > 2.hours || members.count > 100
	end

	def current_player_stats
		@current_player_stats ||= player_stats.select('DISTINCT ON (player_id) *').order('player_id, player_stats.created_at DESC').to_a
	end

	def self.find_or_load(id, force_load: false)
		clan = self.find_by id: id
		if clan.nil? || force_load || clan.needs_update?
			api_data =  self.load_data_from_api(id)
			clan = self.create!(id: id) if clan.nil?
			clan.update!({status: :ok}.merge(api_data[:clan]))
			clan.touch
			clan.update_players(api_data[:members])
		end
		clan
	end

	def self.load_data_from_api(id)
		Rails.logger.info "Updating clan #{id} from API"
		response = WargamingApi.new(Regions.from_id(id)).clan_info([id]).parsed_response
		data = response['data'][id.to_s]
		{
			clan: {
				name: data['name'],
				tag: data['abbreviation'],
				motto: data['motto'],
				description: data['description_html']
			}, members: data['members'].map { |aid, row| {id: aid, name: row['account_name'], role: row['role']} }
		}
	end

	def update_players(members_data)
		Player.transaction do
			members_data.each do |player_data|
				player = Player.find_or_create_by!(id: player_data[:id])
				player.update!({status: :ok, clan_id: id}.merge(player_data))
			end

			members.each do |member|
				member.update_attribute(:clan_id, 0) unless members_data.any? { |md| md[:id].to_i == member.id }
			end
		end

		members.reload
	end
end
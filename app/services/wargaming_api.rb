class WargamingApi
	include HTTParty

	FIELDS = {
		clan: {
			info: 'description_html,abbreviation,motto,name,members.account_id,members.account_name,members.created_at,members.role'
		},
		account: {
			stats: 'statistics.all'
		},
		tankopedia: 'nation,name,level,contour_image,name_i18n,type'
	}

	def initialize(region)
		@options = {
			base_uri: "http://api.#{Regions.get_host(region)}/wot",
			query: {
				application_id: get_api_id(region)
			}
		}
	end

	def clan_info(ids)
		self.class.get('/clan/info/', @options.deep_merge(
			query: {
				fields: FIELDS[:clan][:info],
				clan_id: ids.join(',')
			}
		))
	end

	def account_stats(ids)
		self.class.get('/account/info/', @options.deep_merge(
			query: {
				fields: FIELDS[:account][:stats],
				account_id: ids.join(','),
				type: 'all'
			}
		))
	end

	def tank_stats(ids)
		self.class.get('/account/tanks/', @options.deep_merge(
			query: {
				account_id: ids.join(',')
			}
		))
	end

	def clan_search(search, page = 1)
		self.class.get('/clan/list/', @options.deep_merge(
			query: {
				search: search,
				order_by: 'abbreviation',
				limit: 50,
				page_no: page
			}
		))
	end

	def tankopedia
		self.class.get('/encyclopedia/tanks/', @options.deep_merge(
			query: {
				language: 'en',
				fields: FIELDS[:tankopedia]
			}
		))
	end

	def get_api_id(region)
		%w{171745d21f7f98fd8878771da1000a31 d0a293dc77667c9328783d489c8cef73 16924c431c705523aae25b6f638c54dd
			39b4939f5f2460b3285bfa708e4b252c ?? ffea0f1c3c5f770db09357d94fe6abfb}[region]
	end
end
class Regions
	SUPPORTED_REGIONS = {
		0 => 'RU',
		1 => 'EU',
		2 => 'NA',
		3 => 'ASIA',
		5 => 'KR'
	}

	def self.from_id(id)
		bounds = [0, 500000000, 1000000000, 2000000000, 2500000000, 3000000000]
		region = bounds.length - 1
		while bounds[region] > id
			region -= 1
		end
		region
	end

	def self.get_host(region)
		%w{worldoftanks.ru worldoftanks.eu worldoftanks.com worldoftanks.asia portal-wot.go.vn worldoftanks.kr}[region]
	end

	def self.emblem_url(id, size = '64x64')
		region = from_id(id)
		"http://clans.#{get_host(region)}/media/clans/emblems/cl_#{id.to_s[-3..-1]}/#{id}/emblem_#{size}.png"
	end
end

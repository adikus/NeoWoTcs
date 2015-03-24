module ApplicationHelper
	def title
		@locals[:title].present? ? "WoTcs | #{@locals[:title]}" : 'WoTcs | Clan and player statistics'
	end

	def current_region
		@locals[:region]
	end

	def current_region_humanized
		Regions::SUPPORTED_REGIONS[current_region]
	end

	def nav_item
		@locals[:nav_item] || nil
	end
end

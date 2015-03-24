class ClanMemberView
	def initialize(clan)
		@clan = clan

		@member_table = @clan.members.group_by(&:role)
	end

	def count(type = nil)
		if type.nil?
			@member_table.values.sum(&:size)
		else
			@member_table[type.to_s].andand.size || 0
		end
	end

	def has_members?
		@member_table.any?
	end

	def leader
		@member_table['leader'].first
	end

	def vice_leaders
		@member_table['vice_leader'] || []
	end

	def commanders
		@member_table['commander'] || []
	end

	def diplomats
		@member_table['diplomat'] || []
	end

	def recruiters
		@member_table['recruiter'] || []
	end

end
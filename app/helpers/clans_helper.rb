module ClansHelper
	def members_name_badge(members)
		if members.any?
			content_tag('span', class: 'badge', title: members.map(&:name).join(', ')) do
				"#{members.first.name}" + (members.count > 1 ? " and #{members.count - 1} more" : '')
			end
		end
	end
end

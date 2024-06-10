Hooks:PreHook(StageEndScreenGui, "feed_statistics", "feed_statistics_smth", function(self, data, ...)
    data.mitigation_damage = string.format("%.2f", managers.statistics:mitigation_damage())
	data.heal_amount = string.format("%.2f", managers.statistics:heal_amount())
	data.session_damage_2 = tostring(managers.statistics:session_damage_string())
end) 


Hooks:PreHook(StatsTabItem, "set_stats", "set_stats_smth", function(self, stats_data, ...)
    if table.contains(stats_data, "favourite_weapon") then
		if DHMEndScreen.settings.healmit_mit_enabled then
		    table.insert(stats_data, 1, "mitigation_damage")
		end
		if DHMEndScreen.settings.healmit_heal_enabled then
		    table.insert(stats_data, 1, "heal_amount")
		end
		if DHMEndScreen.settings.healmit_dmg_enabled then
	        table.insert(stats_data, 1, "session_damage_2")
		end
	end
end)


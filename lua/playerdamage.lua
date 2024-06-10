Hooks:PreHook(PlayerDamage, "_calc_armor_damage", "_calc_mitigation_damage", function(self, attack_data, ...)
    if attack_data.damage > self:get_real_armor() and self:get_real_armor() ~= 0 then
	    local mit = mit or attack_data.damage - self:get_real_armor()
		managers.statistics:add_mitigation_damage(mit)
	elseif attack_data.damage <= self:get_real_armor() and self:get_real_armor() ~= 0 then
	    managers.statistics:add_mitigation_damage(attack_data.damage)
	end
end) 

Hooks:PreHook(PlayerDamage, "change_health", "_calc_heal", function(self, change_of_health, ...)
	local currenthp = self:get_real_health()
	local maxhp = self:_max_health()
	local heal = change_of_health 
	hpratio = currenthp/maxhp
	if heal > 0 and hpratio < 0.99 then
	    if heal == maxhp then
		    managers.statistics:add_heal_amount(maxhp - currenthp)
		else
		    managers.statistics:add_heal_amount(heal)
		end
	end
end)


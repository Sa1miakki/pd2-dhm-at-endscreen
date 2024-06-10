local _update_debug_ws_original = CopDamage._update_debug_ws

function CopDamage:_update_debug_ws(damage_info, ...)
	if damage_info and type(damage_info) == "table" then
		CopDamage:_process_damage_a(damage_info)
	end
	return _update_debug_ws_original(self, damage_info, ...)
end

function CopDamage:_process_damage_a(damage_info)
	local attacker = alive(damage_info.attacker_unit) and damage_info.attacker_unit
	local damage = tonumber(damage_info.damage) or 0

	if attacker and damage >= 0.1 then
		local killer

		if attacker:in_slot(3) or attacker:in_slot(5) then
				--Human team mate
			killer = attacker
		elseif attacker:in_slot(2) then
				--Player
			killer = attacker
		elseif attacker:in_slot(16) then
				--Bot/joker
			killer = attacker
		elseif attacker:in_slot(12) then
				--Enemy
		elseif attacker:in_slot(25)	then
				--Turret
			local owner = attacker:base():get_owner_id()
			if owner then
				killer =  managers.criminals:character_unit_by_peer_id(owner)
			end
		elseif attacker:base().thrower_unit then
			killer = attacker:base():thrower_unit()
		end

		if alive(killer) then
			if killer:in_slot(2) then
				if managers.statistics and DHMEndScreen.settings.healmit_dmg_enabled then
					managers.statistics:add_session_damage(damage)
				end

				if managers.hud and managers.hud.update_stats_screen then
					managers.hud:update_stats_screen()
				end
			else
				local peer_id = managers.criminals:character_peer_id_by_unit(killer)
				if peer_id and DHMEndScreen.settings.healmit_dmg_enabled then
					managers.statistics:add_session_damage(damage, peer_id)
				end
			end
		end
	end
end
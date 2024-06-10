function StatisticsManager:mitigation_damage()
	self._mitigation_damage = self._mitigation_damage or 0
	return self._mitigation_damage
end

function StatisticsManager:add_mitigation_damage(damage)
	self._mitigation_damage = self._mitigation_damage or 0
	self._mitigation_damage = (self._mitigation_damage or 0 ) + (damage * 10)
end

function StatisticsManager:heal_amount()
	self._heal_amount = self._heal_amount or 0
	return self._heal_amount
end

function StatisticsManager:add_heal_amount(amount)
	self._heal_amount = self._heal_amount or 0
	self._heal_amount = (self._heal_amount or 0 ) + (amount * 10)
end

function StatisticsManager:deal_damage()
	self._deal_damage = self._deal_damage or 0
	return self._deal_damage or 0
end

function StatisticsManager:add_deal_damage(damage)
	self._deal_damage = self._deal_damage or 0
	self._deal_damage = (self._deal_damage or 0 ) + (damage * 10)
end

----VanillaHUDPlus----

function StatisticsManager:session_damage(peer_id)
	local peer = peer_id and managers.network:session():peer(peer_id)
	local peer_uid = peer and peer:user_id() or managers.network.account:player_id()
	self._session_damage = self._session_damage or {}
	return math.round(self._session_damage[peer_uid] or 0)
end

function StatisticsManager:session_damage_string(peer_id)
	local damage = self:session_damage(peer_id)
	return managers.money:add_decimal_marks_to_string(tostring(damage))
end

function StatisticsManager:add_session_damage(damage, peer_id)
	local peer = peer_id and managers.network:session():peer(peer_id)
	local peer_uid = peer and peer:user_id() or managers.network.account:player_id()
	self._session_damage = self._session_damage or {}
	self._session_damage[peer_uid] = (self._session_damage[peer_uid] or 0 ) + (damage * 10)
end

function StatisticsManager:reset_session_damage(peer_id)
	local peer = peer_id and managers.network:session():peer(peer_id)
	local peer_uid = peer and peer:user_id() or managers.network.account:player_id()
	self._session_damage = self._session_damage or {}
	self._session_damage[peer_uid] = 0
end

function StatisticsManager:most_session_damage()
	local user_id, max_damage = nil, 0
	for peer_uid, damage in pairs(self._session_damage or {}) do
		damage = math.round(damage)
		if damage > max_damage then
			max_damage = damage
			user_id = peer_uid
		end
	end

	local peer_name = user_id and managers.network.account:username_id(user_id) or managers.localization:text("debug_undecided")
	return string.format("%s (%s)", peer_name, managers.money:add_decimal_marks_to_string(tostring(max_damage)))
end

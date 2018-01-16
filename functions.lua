local _, ns = ...

local colors = oUF.colors


local PLAYER_FACTION = UnitFactionGroup("player")

function ns.PvP_PostUpdate(element, unit, status)
	if not status then return end
	if status == PLAYER_FACTION then
		return element:Hide()
	elseif status == "Horde" or status == "Alliance" then
    element:SetTexture(element.tex[status])
		return element:Show()
  else
		return element:Hide()
	end
end

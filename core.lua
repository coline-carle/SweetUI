--get the addon namespace
local _, ns = ...

--get oUF namespace (just in case needed)
local oUF = ns.oUF or oUF

local Loader = CreateFrame("Frame")
Loader:RegisterEvent("ADDON_LOADED")
Loader:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, event, ...)
end)

-- unit uconfig
ns.uconfig = {
	player = {
		point = "BOTTOMRIGHT UIParent CENTER -200 -200",
		width = 1.3,
		power = true,
		castbar = true,
	},
}

function Loader:ADDON_LOADED(event, addon)
  print("ADDON LOADED")
  ns.frames  = {}

  -- cleanup
  self:UnregisterEvent(event)
  self.ADDON_LOADED = nil

  -- Go
	oUF:Factory(ns.Factory)
end


local function Spawn(self, unit, isSingle)
  if self:GetParent():GetAttribute("useOwnerUnit") then
		local suffix = self:GetParent():GetAttribute("unitsuffix")
		self:SetAttribute("useOwnerUnit", true)
		self:SetAttribute("unitsuffix", suffix)
		unit = unit .. suffix
	end

  local uconfig = ns.uconfig[unit]
  self.spawnunit = unit

  local portraitSize =  64
  local backSize = portraitSize + 31
  local anchor = 400
  local insideCircle = 0.21

  if unit=="player" then



    local portrait = CreateFrame("PlayerModel", nil, self)
    portrait:SetPoint("TOP", "UIParent", "BOTTOM", 0, anchor)
    portrait:SetFrameStrata("BACKGROUND")
    portrait:SetSize(portraitSize, portraitSize)

    portrait.type = "3D"
    self.Portrait = portrait

    local borderFrame = CreateFrame("Frame", nil, portrait)
    borderFrame:SetPoint("CENTER")
    borderFrame:SetFrameStrata("LOW")
    borderFrame:SetSize(backSize, backSize)


    local rimBackground = borderFrame:CreateTexture(nil, "BACKGROUND")
    rimBackground:SetTexture([[Interface\AddOns\SweetUI\Media\BG\Circle Frame 04]])
    rimBackground:SetAllPoints(borderFrame)
    rimBackground:SetVertexColor(0.4, 0.4, 0.4, 1.0)
    rimBackground:SetTexCoord(insideCircle, 1 - insideCircle, insideCircle, 1 - insideCircle)

    local rim = borderFrame:CreateTexture(nil, "BORDER")
    rim:SetTexture([[Interface\AddOns\SweetUI\Media\BG\Circle Frame 04]])
    rim:SetAllPoints(borderFrame)
    rim:SetVertexColor(0.67, 0.91, 1.0, 1.0)
    rim:SetTexCoord(insideCircle, 1 - insideCircle, insideCircle, 1 - insideCircle)


    local outerRim = borderFrame:CreateTexture(nil, "BORDER")
    outerRim:SetTexture([[Interface\AddOns\SweetUI\Media\Other\Circle Rim]])
    outerRim:SetAllPoints(borderFrame)
    outerRim:SetBlendMode("ADD")
    outerRim:SetVertexColor(0.5, 1.0, 0.96, 0.8)
    outerRim:SetTexCoord(0, 1, 0, 1)


    --

    -- border:SetVertexColor(0.07, 0.33, 0.08, 0.5)

  end

end

function ns.Factory(oUF)
  -- register style
  oUF:RegisterStyle("SweetUI", Spawn)
  oUF:SetActiveStyle("SweetUI")

  local uconfig = ns.uconfig
  for unit, udata in pairs(uconfig) do
    if not udata.disable then
      local name = "oUFSweet" .. unit:gsub("%a", strupper, 1):gsub("target", "Target"):gsub("pet", "Pet")
      if udata.point then
        print("generating frame for", unit)
				ns.frames[unit] = oUF:Spawn(unit, name)
      end
    end
  end
end

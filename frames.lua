--get the addon namespace
local _, ns = ...

ns.objects,  ns.frames = {}, {}

local config

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

  local FRAME_WIDTH  = config.width  * (uconfig.width  or 1)
  local FRAME_HEIGHT = config.height * (uconfig.height or 1)
  local POWER_HEIGHT = FRAME_HEIGHT * config.powerHeight

  self:SetWidth(FRAME_WIDTH)
  self:SetHeight(FRAME_HEIGHT)

  -------------------------
  -- Border and backdrop --
  -------------------------

  self:SetBackdrop(config.backdrop)
  self:SetBackdropColor(0, 0, 0, 1)
  self:SetBackdropBorderColor(unpack(config.borderColor))

  -----------------------------------------------------------
	-- Overlay to avoid reparenting stuff on powerless units --
	-----------------------------------------------------------
	self.overlay = CreateFrame("Frame", nil, self)
	self.overlay:SetAllPoints(true)

  -------------------------
	-- Health bar and text --
	-------------------------
	local health = ns.CreateStatusBar(self, 24, "RIGHT", uconfig.healthbar)
	health:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -1)
	health:SetPoint("TOPRIGHT", self, "TOPRIGHT", -1, -1)
	health:SetPoint("BOTTOM", self, "BOTTOM", 0, 1)

	health.texture:SetDrawLayer("ARTWORK")



	health.value:SetParent(self.overlay)
	health.value:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, FRAME_HEIGHT * config.powerHeight - 4)
  self.Health = health

  if uconfig.power then
    local power = ns.CreateStatusBar(self, uconfig.width, "LEFT")
    power:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 1, 1)
    power:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 1)
    power:SetHeight(POWER_HEIGHT)

    health:SetPoint("BOTTOM", power, "TOP", 0, 1)

    self.Power = power
  end


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

  end
end

function ns.Factory(oUF)
  -- register style
  oUF:RegisterStyle("SweetUI", Spawn)
  oUF:SetActiveStyle("SweetUI")

  local uconfig = ns.uconfig
  config = ns.config

  for unit, udata in pairs(uconfig) do
    if not udata.disable then
      local name = "oUFSweet" .. unit:gsub("%a", strupper, 1):gsub("target", "Target"):gsub("pet", "Pet")
      if udata.point then
        print("generating frame for", unit)
				ns.frames[unit] = oUF:Spawn(unit, name)
      end
    end
  end

  for unit, object in pairs(ns.frames) do
    local udata = uconfig[unit]
    local p1, parent, p2, x, y = string.split(" ", udata.point)
    object:ClearAllPoints()
    object:SetPoint(p1, UIParent, p2, tonumber(x) or 0, tonumber(y) or 0)
  end
end

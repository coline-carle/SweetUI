--get the addon namespace
local _, ns = ...

ns.objects,  ns.frames = {}, {}

local config

local colors = oUF.colors


local function Spawn(self, unit, isSingle)
  if self:GetParent():GetAttribute("useOwnerUnit") then
		local suffix = self:GetParent():GetAttribute("unitsuffix")
		self:SetAttribute("useOwnerUnit", true)
		self:SetAttribute("unitsuffix", suffix)
		unit = unit .. suffix
	end

  local uconfig = ns.uconfig[unit]
  self.spawnunit = unit

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
  if uconfig.detailed then
  	local health = ns.CreateStatusBar(self, 24, "RIGHT", config.health, uconfig.mirror)
  	health:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -1)
  	health:SetPoint("TOPRIGHT", self, "TOPRIGHT", -1, -1)
  	health:SetPoint("BOTTOM", self, "BOTTOM", 0, 1)

    health.texture:SetVertexColor(0.43, 0.83, 0.79)
  	health.texture:SetDrawLayer("ARTWORK")

    health.value:SetParent(self.overlay)
  	health.value:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, - 4)
    self.Health = health

    local power = ns.CreateStatusBar(self, uconfig.width, "LEFT", config.power, uconfig.mirror)
    local left, right = config.power.left, config.power.right
    if uconfig.mirror then
      left, right = -right, -left
    end
    power:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", left, 0)
    power:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", right, 0)
    power:SetHeight(POWER_HEIGHT)

    power.bg.multiplier = config.power.multiplier
    local powerColorMode = uconfig.powerColorMode
    power.colorClass = powerColorMode == "CLASS"
    power.colorPower = powerColorMode == "POWER"

    -- health:SetPoint("BOTTOM", power, "TOP", 0, 1)

    if uconfig.mirror then
      self.leftArt = ns.CreateArt(self, config.mirrorArt.left, uconfig.mirror)
      self.rightArt = ns.CreateArt(self, config.mirrorArt.right, uconfig.mirror)
    else
      self.leftArt = ns.CreateArt(self, config.art.left)
      self.rightArt = ns.CreateArt(self, config.art.right)
    end



    if unit == "target" then



      local PvPFrame = CreateFrame("Frame", nil, self)

      PvPFrame:SetSize(config.blazon.size, config.blazon.size)
      local p1, p2 = strsplit(" ", config.blazon.anchor)
      PvPFrame:SetPoint(p1, self, p2, config.blazon.x, config.blazon.y)

      local PvPIndicator = PvPFrame:CreateTexture(nil, "OVERLAY")
      PvPIndicator.file = {}
      PvPIndicator.file["Alliance"] = LibStub("LibSharedMedia-3.0"):Fetch("texture", config.blazon.Alliance)
      PvPIndicator.file["Horde"] = LibStub("LibSharedMedia-3.0"):Fetch("texture", config.blazonHorde)

      PvPIndicator:SetAllPoints(PvPFrame)
      PvPIndicator.PostUpdate = ns.PvP_PostUpdate

      self.PvP = PvPFrame
      self.PvPIndicator = PvPIndicator
    end




    self.Power = power



    -- decorations

  end



  if unit=="player" then
      self.Portrait = ns.CreatePortrait(self, uconfig.portrait)
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
    local p1, parent, p2, x, y = strsplit(" ", udata.point)
    object:ClearAllPoints()
    object:SetPoint(p1, UIParent, p2, tonumber(x) or 0, tonumber(y) or 0)
  end
end

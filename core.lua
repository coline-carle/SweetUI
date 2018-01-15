--get the addon namespace
local _, ns = ...

--get oUF namespace (just in case needed)
local oUF = ns.oUF or oUF
local Media

local FALLBACK_FONT_SIZE = 16

local Loader = CreateFrame("Frame")
Loader:RegisterEvent("ADDON_LOADED")
Loader:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, event, ...)
end)

ns.config = {
  width = 225,
  height = 30,
  powerHeight = 0.2,

  font = "vixar",
  fontScale = 1,
  fontShadow = true,
  fontOutline = "OUTLINE",

  backdropColor = { 32/256, 35/256, 32/256, 1},
  borderColor = { 0.5, 0.5, 0.5 },
}


-- unit uconfig
ns.uconfig = {
	player = {
		point = "BOTTOMRIGHT UIParent CENTER -200 -200",
		width = 1.3,
		power = true,
    healthbar = {
      texture = "Status Bar 03",
      bg = "Status Bar 04",
    }

	},
}



function Loader:ADDON_LOADED(event, addon)
  print("ADDON LOADED")
  ns.frames  = {}
  ns.statusbars = {}
  ns.fontstrings = {}

  Media  = LibStub("LibSharedMedia-3.0")
  Media:Register("font", "vixar", [[Interface\AddOns\SweetUI\Media\Fonts\vixar.ttf]])
  Media:Register("statusbar", "Status Bar 03", [[Interface\AddOns\SweetUI\Media\Bar\Status Bar 03 Croped]])
  Media:Register("statusbar", "Status Bar 04", [[Interface\AddOns\SweetUI\Media\Bar\Status Bar 04 Croped]])


  -- cleanup
  self:UnregisterEvent(event)
  self.ADDON_LOADED = nil

  -- Go
	oUF:Factory(ns.Factory)
end



function ns.CreateFontString(parent, size, justify)
	local file = ns.GetFontFile()
	if not size or size < 6 then size = FALLBACK_FONT_SIZE end
	size = size * ns.config.fontScale

	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(file, size, ns.config.fontOutline)
	fs:SetJustifyH(justify or "LEFT")
	fs:SetShadowOffset(ns.config.fontShadow and 1 or 0, ns.config.fontShadow and -1 or 0)
	fs:SetWordWrap(false)
	fs.baseSize = size

	tinsert(ns.fontstrings, fs)
	return fs
end

function ns.GetFontFile()
  return Media:Fetch("font", ns.config.font) or STANDARD_TEXT_FONT
end

function ns.CreateStatusBar(parent, size, justify, bar)
  local file
  if bar and bar.texture then
    file = Media:Fetch("statusbar", bar.texture)
    print(file)
  else
    file = "Interface\\TargetingFrame\\UI-StatusBar"
  end


  local sb = CreateFrame("StatusBar", "oUFSweetUIStatusBar"..(1 + #ns.statusbars), parent)
  sb:SetStatusBarTexture(file)
  tinsert(ns.statusbars, sb)



  if bar and bar.bg then
    local bgFile = Media:Fetch("statusbar", bar.bg)
    sb.bg = sb:CreateTexture(nil, "BACKGROUND")
    sb.bg:SetTexture(bgFile)
    sb.bg:SetAllPoints(true)
    tinsert(ns.statusbars, sb.bg)
  end

  if size then
			sb.value = ns.CreateFontString(sb, size, justify)
	end

  sb.texture = sb:GetStatusBarTexture()
	sb.texture:SetDrawLayer("BORDER")
	sb.texture:SetHorizTile(false)
	sb.texture:SetVertTile(false)

  return sb
end

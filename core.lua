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



function Loader:ADDON_LOADED(event, addon)
  ns.frames  = {}
  ns.statusbars = {}
  ns.fontstrings = {}

  Media  = LibStub("LibSharedMedia-3.0")
  Media:Register("font", "vixar", [[Interface\AddOns\SweetUI\Media\Fonts\vixar.ttf]])
  Media:Register("statusbar", "Status Bar 03", [[Interface\AddOns\SweetUI\Media\Bar\Status Bar 03 Croped]])
  Media:Register("statusbar", "Status Bar 04", [[Interface\AddOns\SweetUI\Media\Bar\Status Bar 04 Croped]])
  Media:Register("statusbar", "Status Bar 05", [[Interface\AddOns\SweetUI\Media\Bar\Status Bar 05]])
  Media:Register("texture", "Circle Frame 04", [[Interface\AddOns\SweetUI\Media\BG\Circle Frame 04]])
  Media:Register("texture", "Circle Rim", [[Interface\AddOns\SweetUI\Media\Other\Circle Rim]])

  Media:Register("texture", "Unit Frame 13 Left", [[Interface\AddOns\SweetUI\Media\BG\Unit Frame 13 Left]])
  Media:Register("texture", "Unit Frame 13 Right", [[Interface\AddOns\SweetUI\Media\BG\Unit Frame 13 Right]])


  -- cleanup
  self:UnregisterEvent(event)
  self.ADDON_LOADED = nil

  -- Go
	oUF:Factory(ns.Factory)
end


function ns.CreatePortrait(parent, pconfig)
  local portrait = CreateFrame("PlayerModel", nil, parent)
  local p1, parent, p2, x, y = string.split(" ", pconfig.point)
  portrait:SetPoint(p1, parent, p2, tonumber(x) or 0, tonumber(y) or 0)
  portrait:SetFrameStrata("BACKGROUND")
  portrait:SetSize(pconfig.size, pconfig.size)

  portrait.type = "3D"


  local rimFrame = CreateFrame("Frame", nil, portrait)
  rimFrame:SetPoint("CENTER")
  rimFrame:SetFrameStrata("LOW")
  rimFrame:SetSize(pconfig.backSize, pconfig.backSize)

  local texture
  local r, g, b, a

  local insideRimInset = pconfig.textures.insideRimInset


  local rimBackground = rimFrame:CreateTexture(nil, "BACKGROUND")
  texture = Media:Fetch("texture", pconfig.textures.rimBackground)
  rimBackground:SetTexture(texture)
  rimBackground:SetAllPoints(rimFrame)
  r, g, b, a = strsplit(", ", pconfig.textures.rimBackgroundColor)
  rimBackground:SetVertexColor(tonumber(r), tonumber(g), tonumber(b), tonumber(a))
  rimBackground:SetTexCoord(insideRimInset, 1 - insideRimInset,
                            insideRimInset, 1 - insideRimInset)

  local rim = rimFrame:CreateTexture(nil, "BORDER")
  texture = Media:Fetch("texture", pconfig.textures.rim)
  rim:SetTexture(texture)
  rim:SetAllPoints(rimFrame)
  r, g, b, a = strsplit(", ", pconfig.textures.rimColor)
  rim:SetVertexColor(tonumber(r), tonumber(g), tonumber(b), tonumber(a))
  rim:SetTexCoord(insideRimInset, 1 - insideRimInset,
                  insideRimInset, 1 - insideRimInset)


  local outerRim = rimFrame:CreateTexture(nil, "BORDER")
  texture = Media:Fetch("texture", pconfig.textures.outterRim)
  outerRim:SetTexture(texture)
  outerRim:SetAllPoints(rimFrame)
  outerRim:SetBlendMode("ADD")
  r, g, b, a = strsplit(", ", pconfig.textures.outerRimColor)
  outerRim:SetVertexColor(tonumber(r), tonumber(g), tonumber(b), tonumber(a))
  outerRim:SetTexCoord(0, 1, 0, 1)

  return portrait
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

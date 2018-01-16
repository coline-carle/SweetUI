--get the addon namespace
local _, ns = ...

--get oUF namespace (just in case needed)
local oUF = ns.oUF or oUF
local Media

oUF.colors.power["MANA"] = { 0.68, 0.37, 0.0 }
oUF.colors.power["RAGE"] = { 1, 0, 0 }
oUF.colors.power["ENERGY"] = { 0.96, 1, 0.42 }


oUF.colors.class["DRUID"] = { 0.52, 0.76, 1.0 }
oUF.colors.class["WARRIOR"] = { 0.53, 0.39, 0.33 }
oUF.colors.class["PALADIN"] = { 0.98, 0.52, 0.58 }
oUF.colors.class["HUNTER"] = { 0.65, 1, 0.61 }
oUF.colors.class["ROGUE"] = {  0.96, 1, 0.42 }
oUF.colors.class["DEATHKNIGHT"] = {  0.6, 0.12, 0 }
oUF.colors.class["SHAMAN"] = {  0.6, 0.12, 0 }
oUF.colors.class["MAGE"] = {  0.52, 0.76, 1 }
oUF.colors.class["WARLOCK"] = {  0.83, 0.65, 1 }
oUF.colors.class["MONK"] = {  0.36, 0.99, 0.68 }

ns.config = {
  width = 225,
  height = 30,
  powerHeight = 0.24,

  health = {
    texture = "Status Bar 03",
    mirror = "Status Bar 03 Mirror",
    bg = "Status Bar 04",
  },
  power = {
    texture = "Status Bar 05",
    mirror = "Status Bar 05 Mirror",
    left = 25,
    right = -48,
    height = 0.24,
    multiplier = 0.25,
  },
  blazon = {
    Alliance = "Alliance Icon",
    Horde = "Horde Icon",
    size = 32,
    anchor = "CENTER TOPRIGHT",
    x = - 58,
    y = 5,
  },

  mirrorArt = {
    left = {
      texture = "Unit Frame 13 Right",
      x = 37,
      y = 0,
      anchor = "CENTER LEFT",
      size = 140,
    },
    right = {
      texture ="Unit Frame 13 Left",
      x = -48,
      y = 0,
      anchor = "CENTER RIGHT",
      size = 128,
    }
  },

  art = {
    left = {
      texture = "Unit Frame 13 Left",
      x = 52,
      y = 0,
      anchor = "CENTER LEFT",
      size = 140,
    },
    right = {
      texture ="Unit Frame 13 Right",
      x = -36,
      y = 0,
      anchor = "CENTER RIGHT",
      size = 128,
    }
  },

  font = "vixar",
  fontScale = 1,
  fontShadow = true,
  fontOutline = "OUTLINE",

  backdropColor = { 32/256, 35/256, 32/256, 1},
  borderColor = { 0.5, 0.5, 0.5 },
}


-- unit uconfig
ns.uconfig = {
  target = {
		point = "BOTTOMLEFT UIParent CENTER 200 -200",
		width = 1.3,
    powerColorMode = "CLASS",
    mirror = true,
		detailed = true,
  },
	player = {
		point = "BOTTOMRIGHT UIParent CENTER -200 -200",
		width = 1.3,
		detailed = true,
    powerColorMode = "POWER",
    portrait = {
      size = 64,
      backSize = 91,
      point = "BOTTOM UIParent CENTER 0 -200",
      textures = {
        rimBackground = "Circle Frame 04",
        rimBackgroundColor = "0.4 0.4 0.4 1.0",
        outerRim = "Circle Rim",
        outerRimColor = "0.5 1.0 0.96 0.8",
        rim = "Circle Frame 04",
        rimColor = "0.67 0.91 1.0 1.0",
        insideRimInset = 0.21,
      }
    }
	},
}

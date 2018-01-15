--get the addon namespace
local _, ns = ...

ns.config = {
  width = 225,
  height = 30,
  powerHeight = 0.24,

  health = {
    texture = "Status Bar 03",
    bg = "Status Bar 04",
  },
  power = {
    texture = "Status Bar 05",
    left = 18,
    right = 37,
    height = 0.24,
  },

  background = {
    left = "Unit Frame 13 Left",
    right ="Unit Frame 13 Right",
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
	player = {
		point = "BOTTOMRIGHT UIParent CENTER -200 -200",
		width = 1.3,
		detailed = true,
    portrait = {
      size = 64,
      backSize = 91,
      point = "BOTTOM UIParent BOTTOM 0 400",
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

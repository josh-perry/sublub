lg = love.graphics

local player
local camera
local sonar
local enemies

Camera = require("libs.hump.camera")
states = require("states")

lg.setDefaultFilter("nearest", "nearest")

drawWater = ->
  lg.setColor(0, 0.47, 0.76, 0.75, 0.75)
  lg.rectangle("fill", 0, 0, lg\getWidth!, lg\getHeight!)

love.load = ->
  player = require("player")!
  camera = Camera(player.x, player.y)

  enemies = {
    require("Enemy")("assets/ship1.png", 80, 126, 47)
  }

  sonar = require("sonar")!

viewStencil = ->
  lg.setColor(1, 1, 1)
  lg.circle("fill", lg.getWidth! / 2, lg.getHeight! / 2, player.viewRadius)

love.draw = ->
  if player.state ~= states.Surface
    lg.stencil(viewStencil, "replace")
    lg.setStencilTest("greater", 0)

  camera\attach!

  for i, v in ipairs(enemies)
    v.drawable\drawSurface!

  player.drawable\drawSurface!

  drawWater!

  player.drawable\drawOutline!
  player.drawable\drawUnderwater!

  for i, v in ipairs(enemies)
    v.drawable\drawOutline!
    v.drawable\drawUnderwater!

  camera\detach!

  lg.setStencilTest()

  sonar\draw!

love.update = (dt) ->
  player\update(dt)

  for i, v in ipairs(enemies)
    v\update(dt)

  dx = player.x - camera.x
  dy = player.y - camera.y

  camera\move(dx, dy)

  sonar\update(dt)

love.keypressed = (key) ->
  if key == "escape"
    love.event.quit!

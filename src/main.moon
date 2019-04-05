lg = love.graphics

local player
local camera
local enemies

Camera = require("libs.hump.camera")

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
  
love.draw = ->
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

love.update = (dt) ->
  player\update(dt)

  for i, v in ipairs(enemies)
    v\update(dt)

  dx = player.x - camera.x
  dy = player.y - camera.y

  camera\move(dx, dy)

love.keypressed = (key) ->
  if key == "escape"
    love.event.quit!

lg = love.graphics

local player
local camera

Camera = require("libs.hump.camera")

drawWater = ->
  lg.setColor(0, 0.47, 0.76, 0.75, 0.75)
  lg.rectangle("fill", 0, 0, lg\getWidth!, lg\getHeight!)

love.load = ->
  player = require("player")!
  camera = Camera(player.x, player.y)
  
love.draw = ->
  camera\attach!

  player.drawable\drawSurface!

  drawWater!

  player.drawable\drawOutline!
  player.drawable\drawUnderwater!

  camera\detach!

love.update = (dt) ->
  player\update(dt)

  dx = player.x - camera.x
  dy = player.y - camera.y

  camera\move(dx, dy)

love.keypressed = (key) ->
  if key == "escape"
    love.event.quit!

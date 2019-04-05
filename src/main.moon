lg = love.graphics

local player

love.load = ->
  lg.setBackgroundColor(.6, .6, 1)

  player = require("player")!
  
love.draw = ->
  player\draw!

love.update = (dt) ->
  player\update(dt)

love.keypressed = (key) ->
  if key == "escape"
    love.event.quit!

  if key == "s"
    player.z += 1

  elseif key == "w"
    player.z -= 1

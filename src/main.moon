lg = love.graphics

love.load = ->
  lg.setBackgroundColor(.6, .6, 1)
  
love.draw = ->
  love.graphics.print(love.timer.getFPS())

love.update = (dt) ->
  x += 50 * dt

love.keypressed = (key) ->
  if key == "escape"
    love.event.quit!

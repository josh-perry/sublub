local lg = love.graphics
local x = 0
love.load = function()
  return lg.setBackgroundColor(.6, .6, 1)
end
love.draw = function()
  love.graphics.print(love.timer.getFPS())
  love.graphics.setColor(1, 0, 0)
  return love.graphics.rectangle("fill", x, 50, 32, 32)
end
love.update = function(dt)
  x = x + (50 * dt)
end
love.keypressed = function(key)
  if key == "escape" then
    return love.event.quit()
  end
end

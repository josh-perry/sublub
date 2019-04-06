lg = love.graphics

class Sonar
  new: =>
    @r = 128
    @x = lg.getWidth! - (@r * 1.5)
    @y = lg.getHeight! - (@r * 1.5)
    @enemies = nil
    @playerX = nil
    @playerY = nil
    
    @lineX, @lineY = nil, nil
    @theta = 0
    @speed = 3

  draw: =>
    lg.setColor(0, 0, 0, .3)
    lg.circle("fill", @x, @y, @r)

    lg.setLineWidth(4)
    lg.setColor(0, 1, 0)
    lg.circle("line", @x, @y, @r)

    lg.setLineWidth(1)
    for i = 1, 4
      lg.circle("line", @x, @y, @r - (@r / 4)*i)

    lg.circle("fill", @x, @y, 8)

    for i = 0, 1, 0.2
      lg.setColor(0, 1, 0, 1-i)
      lg.line(@x, @y, @x + @r * math.cos(@theta - i/2), @y + @r * math.sin(@theta - i/2))
   
    lg.setLineWidth(1)

  update: (dt, playerX, playerY, enemies) =>
    @playerX, @playerY = playerX, playerY
    @theta += dt * @speed

    for i, v in ipairs(enemies)
      distance = math.sqrt(((@playerX - v.x) * (@playerX - v.x)) + ((@playerY - v.y) * (@playerY - v.y)))

return Sonar

lg = love.graphics

tau = require("tau")

class Player
  new: =>
    @asset = lg.newImage("assets/sub1.png")
    @quad = {}
    
    for i = 0, 45
      @quad[i] = love.graphics.newQuad(-60 + 60 * i, 0, 60, 80, @asset\getDimensions!)

    @x = 200
    @y = 200
    @z = 15
    @rotation = 0

    @forwardSpeed = 5
    @rotationSpeed = 2

  draw: =>
    lg.setColor(1, 1, 1)

    for i = 1, @z
      rgb = 0.6 + i / 100
      lg.draw(@asset, @quad[i], @x, @y - i, @rotation, 1, 1, 30, 40)

    lg.setColor(0, 0.47, 0.76, 0.75, 0.75)
    lg.rectangle("fill", 0, 0, lg\getWidth!, lg\getHeight!)

    for i = @z, 45
      rgb = 0.6 + i / 100
      lg.setColor(rgb, rgb, rgb)
      lg.draw(@asset, @quad[i], @x, @y - i, @rotation, 1, 1, 30, 40)

  update: (dt) =>
    if love.keyboard.isDown("a")
      @rotation -= dt * @rotationSpeed
    elseif love.keyboard.isDown("d")
      @rotation += dt * @rotationSpeed

    if love.keyboard.isDown("w")
      @x += @forwardSpeed * math.cos(@rotation + tau)
      @y += @forwardSpeed * math.sin(@rotation + tau)

return Player

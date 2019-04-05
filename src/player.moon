lg = love.graphics

tau = require("tau")

states = {Surface: 1, Diving: 2, Underwater: 3, Surfacing: 4}

class Player
  new: =>
    @asset = lg.newImage("assets/sub1.png")
    @quad = {}
    
    for i = 0, 45
      @quad[i] = love.graphics.newQuad(-60 + 60 * i, 0, 60, 80, @asset\getDimensions!)

    @x = 200
    @y = 200
    @z = 5
    @rotation = 0

    @forwardSpeed = 5
    @rotationSpeed = 2

    @diveSpeed = 15
    @maxDiveDepth = 30

    @dive = false
    @state = states.Surface

  drawSurface: =>
    lg.setColor(1, 1, 1)

    for i = 1, @z
      rgb = 0.6 + i / 100
      lg.draw(@asset, @quad[math.floor(i)], @x, @y - i, @rotation, 1, 1, 30, 40)

  drawUnderwater: =>
    lg.setColor(1, 1, 1)

    for i = @z, 45
      rgb = 0.6 + i / 100
      lg.setColor(rgb, rgb, rgb)
      lg.draw(@asset, @quad[math.floor(i)], @x, @y - i, @rotation, 1, 1, 30, 40)

  drawOutline: =>
    offsetX = 0
    offsetY = 0

    for i = 1, 8
      if i == 1
        offsetX = 1
        offsetY = 0
      if i == 2
        offsetX = -1
        offsetY = 0
      if i == 3
        offsetX = 0
        offsetY = 1
      if i == 4
        offsetX = 0
        offsetY = -1
      if i == 5
        offsetX = 1
        offsetY = 1
      if i == 6
        offsetX = -1
        offsetY = 1
      if i == 7
        offsetX = 1
        offsetY = -1
      if i == 8
        offsetX = -1
        offsetY = -1

      for i = @z, 45
        rgb = 0.6 + i / 100

        lg.setColor(0, 0, 0.1)
        lg.draw(@asset, @quad[math.floor(i)], @x + offsetX, @y + offsetY - i, @rotation, 1, 1, 30, 40)

  movement: (dt) =>
    if love.keyboard.isDown("a")
      @rotation -= dt * @rotationSpeed
    elseif love.keyboard.isDown("d")
      @rotation += dt * @rotationSpeed
    if love.keyboard.isDown("w")
      @x += @forwardSpeed * math.cos(@rotation + tau)
      @y += @forwardSpeed * math.sin(@rotation + tau)
 
  update: (dt) =>
    if @state == states.Surface
      @movement(dt)

      if love.keyboard.isDown("space")
        @state = states.Diving

    elseif @state == states.Diving
      @z += @diveSpeed * dt

      if @z >= @maxDiveDepth
        @z = @maxDiveDepth
        @state = states.Underwater
    elseif @state == states.Underwater
      @movement(dt)

      if love.keyboard.isDown("space")
        @state = states.Surfacing

    elseif @state = states.Surfacing
      @z -= @diveSpeed * dt
      
      if @z <= 0
        @z = 0
        @state = states.Surface

return Player

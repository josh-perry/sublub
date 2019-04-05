lg = love.graphics

tau = require("tau")
states = {Surface: 1, Diving: 2, Underwater: 3, Surfacing: 4}

Drawable = require("Drawable")

class Player
  new: =>
    @drawable = Drawable("assets/sub1.png", 40, 74, 45, 2)
    --@drawable = Drawable("assets/sub2.png", 60, 73, 31)
    --@drawable = Drawable("assets/ship1.png", 80, 126, 47)
    
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

    @drawable\updatePosition(@x, @y, @z, @rotation)

return Player

lg = love.graphics

tau = require("tau")
states = require("states")
models = require("models")

Drawable = require("Drawable")

class Player
  new: =>
    @drawable = Drawable(models["assets/sub1"], 2)

    @x = 200
    @y = 200
    @z = 5
    @rotation = 0

    @forwardSpeed = 5
    @rotationSpeed = 2

    @diveSpeed = 15
    @maxDiveDepth = 30

    @shootTimeout = 0
    @maxShootTimeout = 1

    @dive = false
    @state = states.Surface

    @viewRadius = 512

  movement: (dt) =>
    if love.keyboard.isDown("a")
      @rotation -= dt * @rotationSpeed
    elseif love.keyboard.isDown("d")
      @rotation += dt * @rotationSpeed
    if love.keyboard.isDown("w")
      @x += @forwardSpeed * math.cos(@rotation + tau)
      @y += @forwardSpeed * math.sin(@rotation + tau)
 
  update: (dt, bullets) =>
    if @shootTimeout > 0
      @shootTimeout -= dt

    if @state == states.Surface
      @movement(dt)

      if love.keyboard.isDown("space")
        @state = states.Diving
    elseif @state == states.Diving
      @z += @diveSpeed * dt
      @viewRadius = 512

      if @z >= @maxDiveDepth
        @z = @maxDiveDepth
        @state = states.Underwater
        @viewRadius = 256
    elseif @state == states.Underwater
      @movement(dt)

      if love.keyboard.isDown("space")
        @state = states.Surfacing

      if @shootTimeout <= 0
        if love.keyboard.isDown("z")
          @shootTimeout = @maxShootTimeout
          table.insert(bullets, require("bullet")(models["assets/torpedo"], @x, @y, @rotation))

    elseif @state = states.Surfacing
      @z -= @diveSpeed * dt
      @viewRadius = 512
      
      if @z <= 0
        @z = 0
        @state = states.Surface

    @drawable\updatePosition(@x, @y, @z, @rotation)

return Player

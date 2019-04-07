lg = love.graphics

lume = require("libs.lume")
tau = require("tau")
states = require("states")
models = require("models")
sfx = require("sfx")

Drawable = require("Drawable")

class Player
  new: =>
    @drawable = Drawable(models["assets/sub1"], 2)

    @dead = false

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
  
    @oxygen = 100
    @oxygenDepletionRate = 10
    @oxygenRepletionRate = 5

    @hp = 100

    @viewRadius = 512

  movement: (dt) =>
    if love.keyboard.isDown("left")
      @rotation -= dt * @rotationSpeed
    elseif love.keyboard.isDown("right")
      @rotation += dt * @rotationSpeed

    if love.keyboard.isDown("up")
      @x += @forwardSpeed * math.cos(@rotation + tau)
      @y += @forwardSpeed * math.sin(@rotation + tau)

  update: (dt, bullets) =>
    if @state == states.Underwater
      @oxygen -= @oxygenDepletionRate * dt
    else
      @oxygen += @oxygenRepletionRate * dt

    @oxygen = lume.clamp(@oxygen, 0, 100)

    if @shootTimeout > 0
      @shootTimeout -= dt

    if @state == states.Surface
      @movement(dt)

      if love.keyboard.isDown("x")
        @state = states.Diving
        sfx["DIVING"]\play!

      if @shootTimeout <= 0
        if love.keyboard.isDown("z")
          @shootTimeout = @maxShootTimeout
          
          if sfx["TORPEDO"]\isPlaying!
            sfx["TORPEDO"]\clone!\play!
          else
            sfx["TORPEDO"]\play!
          table.insert(bullets, require("bullet")(models["assets/torpedo"], @x, @y, @rotation))

    elseif @state == states.Diving
      @movement(dt)
      @z += @diveSpeed * dt
      @viewRadius = 512

      if @z >= @maxDiveDepth
        @z = @maxDiveDepth
        @state = states.Underwater
        @viewRadius = 256
    elseif @state == states.Underwater
      @movement(dt)

      if love.keyboard.isDown("x")

        sfx["EMERGE"]\play!
        @state = states.Surfacing
    elseif @state = states.Surfacing
      @movement(dt)
      @z -= @diveSpeed * dt
      @viewRadius = 512
      
      if @z <= 0
        @z = 0
        @state = states.Surface

    @drawable\updatePosition(@x, @y, @z, @rotation)

return Player

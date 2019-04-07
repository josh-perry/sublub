sfx = require("sfx")
state = require("states")
objectives = require("objectives")
models = require("models")
ai = require("ai")
tau = require("tau")

lg = love.graphics

class Enemy
  new: (model, x, y, objective, ai, canShoot, z) =>
    @drawable = require("Drawable")(model, 2)
    @x = x or 250
    @y = y or 250
    @z = z or 10
    @canShoot = canShoot
    @rotation = love.math.random(0, 3.141*2)

    @ai = ai

    @objective = objective
    @sinking = false
    @sinkSpeed = 35

    @rotationSpeed = 0.5
    @forwardSpeed = 1

    @rotationLocked = false

    @shootTimeout = 0
    @maxShootTimeout = 3

    @pickRandomMoveTarget!

  pickRandomMoveTarget: =>
    @moveTargetX = love.math.random(0, lg\getWidth!*3)
    @moveTargetY = love.math.random(0, lg\getHeight!*3)
    @rotationLocked = false

  update: (dt, bullets, player) =>
    if @sinking
      @z += @sinkSpeed * dt
      @drawable\updatePosition(@x, @y, @z, @rotation)
      return

    if @canShoot
      @shootTimeout -= dt

      distance = math.sqrt(((player.x - @x) * (player.x - @x)) + ((player.y - @y) * (player.y - @y)))
      dx = player.x - @x
      dy = player.y - @y
      theta = math.atan2(dy, dx)

      maxShootDistance = 500

      if @shootTimeout <= 0 and player.state ~= state.Underwater
        if distance <= maxShootDistance
          @shootTimeout = @maxShootTimeout
          b = require("bullet")(models["assets/cannonball"], @x, @y, theta - tau)
          b.z = 0
          b.forwardSpeed = 5
          b.playerBullet = false
          table.insert(bullets, b)

          if sfx["ENEMYFIRE"]\isPlaying!
            sfx["ENEMYFIRE"]\clone!\play!
          else
            sfx["ENEMYFIRE"]\play!

    --  @shootTimeout = @maxShootTimeout
    --  
    -- if sfx["TORPEDO"]\isPlaying!
    --   sfx["TORPEDO"]\clone!\play!
    -- else
    --  --  sfx["TORPEDO"]\play!
      --table.insert(bullets, require("bullet")(models["assets/torpedo"], @x, @y, @rotation))

    if @ai == ai.Wander
      dx = @moveTargetX - @x
      dy = @moveTargetY - @y
      theta = math.atan2(dy, dx)

      if @rotation > theta - tau
        @rotation -= @rotationSpeed * dt
      elseif @rotation < theta - tau
        @rotation += @rotationSpeed * dt

      --@rotation = theta - tau

      --print("THETA: "..theta)
      --print("ROTATION: "..@rotation+tau)

      --if theta < @rotation + tau
      --  @rotation -= @rotationSpeed * dt
      --elseif theta > @rotation + tau
      --  @rotation += @rotationSpeed * dt

      if math.abs(@rotation - theta + tau) <= 0.1
        @x += @forwardSpeed * math.cos(@rotation + tau)
        @y += @forwardSpeed * math.sin(@rotation + tau)

      --print(string.format("TARGET XY: %i,%i", @moveTargetX, @moveTargetY))
      --print(string.format("XY: %i,%i", @x, @y))

      if math.abs(@x - @moveTargetX) <= 5 and math.abs(@y - @moveTargetY) <= 5
        @pickRandomMoveTarget!

    @drawable\updatePosition(@x, @y, @z, @rotation)

return Enemy

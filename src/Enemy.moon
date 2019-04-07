objectives = require("objectives")
models = require("models")
ai = require("ai")
tau = require("tau")

lg = love.graphics

class Enemy
  new: (model, x, y, objective, ai) =>
    @drawable = require("Drawable")(model, 2)
    @x = x or 250
    @y = y or 250
    @z = 10
    @rotation = love.math.random(0, 3.141*2)

    @ai = ai

    @objective = objective
    @sinking = false
    @sinkSpeed = 35

    @rotationSpeed = 0.5
    @forwardSpeed = 1

    @rotationLocked = false

    @pickRandomMoveTarget!

    dx = @moveTargetX - @x
    dy = @moveTargetY - @y
    theta = math.atan2(dy, dx)
    --@rotation = theta + tau

  pickRandomMoveTarget: =>
    @moveTargetX = love.math.random(0, lg\getWidth!*3)
    @moveTargetY = love.math.random(0, lg\getHeight!*3)
    @rotationLocked = false

  update: (dt) =>
    if @sinking
      @z += @sinkSpeed * dt

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

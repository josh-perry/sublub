objectives = require("objectives")
models = require("models")

class Enemy
  new: (model, x, y, objective) =>
    @drawable = require("Drawable")(model, 2)
    @x = x or 250
    @y = y or 250
    @z = 0
    @rotation = love.math.random(0, 3.141*2)

    @objective = objective

  update: (dt) =>
    @drawable\updatePosition(@x, @y, @z, @rotation)

return Enemy

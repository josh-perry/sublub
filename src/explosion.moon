models = require("models")

class Explosion
  new: (x, y) =>
    model = models["assets/explosion"]
    @drawable = require("Drawable")(model, 1)

    @x = x
    @y = y
    @z = 0

    @drawable\updatePosition(@x, @y, @z)
    @shrinking = false

  update: (dt) =>
    if @shrinking
      @drawable.scale -= dt*20
    else
      @drawable.scale += dt*10

    @drawable\updatePosition(@x, @y, @z)

    if @drawable.scale >= 5
      @shrinking = true

return Explosion

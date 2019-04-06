tau = require("tau")

class Bullet
  new: (model, x, y, r) =>
    @drawable = require("Drawable")(model, 2)
    @x = x
    @y = y
    @z = 10
    @forwardSpeed = 10
    @rotation = r

  update: (dt) =>
    @x += @forwardSpeed * math.cos(@rotation + tau)
    @y += @forwardSpeed * math.sin(@rotation + tau)

    @drawable\updatePosition(@x, @y, @z, @rotation)

return Bullet

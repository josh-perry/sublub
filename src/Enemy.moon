class Enemy
  new: (imagePath, width, height, zHeight) =>
    @drawable = require("Drawable")(imagePath, width, height, zHeight, 4)
    @x = 250
    @y = 250
    @z = 0

  update: (dt) =>
    @drawable\updatePosition(@x, @y, @z)

return Enemy

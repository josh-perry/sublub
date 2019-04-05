lg = love.graphics

class Drawable
  new: (imagePath) =>
    @asset = lg.newImage(imagePath)
    @quad = {}

    for i = 0, 45
      @quad[i] = love.graphics.newQuad(-60 + 60 * i, 0, 60, 80, @asset\getDimensions!)

  updatePosition: (x, y, z, r) =>
    @x = x
    @y = y
    @z = z
    @rotation = r

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

return Drawable

lg = love.graphics

class Drawable
  new: (imagePath, width, height, zHeight) =>
    @asset = lg.newImage(imagePath)
    @width = width
    @height = height
    @zHeight = zHeight
    @quad = {}

    for i = 0, @zHeight
      @quad[i] = love.graphics.newQuad(-@width + @width * i, 0, @width, @height, @asset\getDimensions!)

  updatePosition: (x, y, z, r) =>
    @x = x
    @y = y
    @z = z
    @rotation = r

  drawSurface: =>
    lg.setColor(1, 1, 1)

    for i = 1, @z
      rgb = 0.6 + i / 100
      lg.draw(@asset, @quad[math.floor(i)], @x, @y - i, @rotation, 1, 1, @width/2, @height/2)

  drawUnderwater: =>
    lg.setColor(1, 1, 1)

    for i = @z, @zHeight
      rgb = 0.6 + i / 100
      lg.setColor(rgb, rgb, rgb)
      lg.draw(@asset, @quad[math.floor(i)], @x, @y - i, @rotation, 1, 1, @width/2, @height/2)

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

      for i = @z, @zHeight
        rgb = 0.6 + i / 100

        lg.setColor(0, 0, 0.1)
        lg.draw(@asset, @quad[math.floor(i)], @x + offsetX, @y + offsetY - i, @rotation, 1, 1, @width/2, @height/2)

return Drawable

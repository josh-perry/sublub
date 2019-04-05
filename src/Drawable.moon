lg = love.graphics

class Drawable
  new: (imagePath, width, height, zHeight, scale) =>
    @asset = lg.newImage(imagePath)
    @width = width
    @height = height
    @zHeight = zHeight
    @scale = scale or 1
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
      lg.draw(@asset, @quad[math.floor(i)], @x, @y - i*@scale, @rotation, @scale, @scale, @width/2, @height/2)

  drawUnderwater: =>
    lg.setColor(1, 1, 1)

    for i = @z, @zHeight
      rgb = 0.6 + i / 100
      lg.setColor(rgb, rgb, rgb)
      lg.draw(@asset, @quad[math.floor(i)], @x, @y - i*@scale, @rotation, @scale, @scale, @width/2, @height/2)

  drawOutline: =>
    offsetX = 0
    offsetY = 0

    for i = 1, 8
      if i == 1
        offsetX = @scale
        offsetY = 0
      if i == 2
        offsetX = -@scale
        offsetY = 0
      if i == 3
        offsetX = 0
        offsetY = @scale
      if i == 4
        offsetX = 0
        offsetY = -@scale
      if i == 5
        offsetX = @scale
        offsetY = @scale
      if i == 6
        offsetX = -@scale
        offsetY = @scale
      if i == 7
        offsetX = @scale
        offsetY = -@scale
      if i == 8
        offsetX = -@scale
        offsetY = -@scale

      for i = @z, @zHeight
        rgb = 0.6 + i / 100

        lg.setColor(0, 0, 0.1)
        lg.draw(@asset, @quad[math.floor(i)], @x + offsetX, @y + offsetY - i*@scale, @rotation, @scale, @scale, @width/2, @height/2)

return Drawable

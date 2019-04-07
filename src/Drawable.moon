lg = love.graphics

lume = require("libs.lume")

class Drawable
  new: (model, scale) =>
    @model = model
    @asset = lg.newImage(@model.path)
    @width = @model.x
    @height = @model.y
    @zHeight = @model.z
    @scale = scale or 1
    @quad = {}
    @offset = love.math.random(0, 1000)

    for i = 0, @zHeight
      @quad[i] = love.graphics.newQuad(-@width + @width * i, 0, @width, @height, @asset\getDimensions!)

  updatePosition: (x, y, z, r) =>
    @x = x
    @y = y
    @z = z + (math.sin(love.timer.getTime! + @offset * 3))
    @rotation = r

  drawSurface: =>
    --lg.setColor(.4, .4, .4, 0.1)
    --lg.setColor(1, 1, 1)

    for i = 1, @z
      if not @quad[lume.round(i)]
        continue

      rgb = 0.1 + i / 100
      
      lg.setColor(rgb, rgb, rgb, 1)
      lg.draw(@asset, @quad[lume.round(i)], @x, @y - i*@scale, @rotation, @scale, @scale, @width/2, @height/2)

  drawUnderwater: =>
    lg.setColor(1, 1, 1)

    for i = @z, @zHeight
      if not @quad[lume.round(i)]
        continue

      rgb = 0.6 + i / 100
      lg.setColor(rgb, rgb, rgb)
      lg.draw(@asset, @quad[lume.round(i)], @x, @y - i*@scale, @rotation, @scale, @scale, @width/2, @height/2)

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
        if not @quad[lume.round(i)]
          continue

        lg.setColor(0, 0, 0.1)
        lg.draw(@asset, @quad[lume.round(i)], @x + offsetX, @y + offsetY - i*@scale, @rotation, @scale, @scale, @width/2, @height/2)

return Drawable

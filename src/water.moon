lg = love.graphics

class Water
  new: (cameraX, cameraY) =>
    @canvas = lg.newCanvas(1280, 720)

    cameraX - lg\getWidth!/2
    cameraY - lg\getHeight!/2

    @grid = {}
    @grid[1] = {x: cameraX, y: cameraY}
    @grid[2] = {x: cameraX + 1790, y: cameraY}
    @grid[3] = {x: cameraX, y: cameraY + 1008}
    @grid[4] = {x: cameraX + 1790, y: cameraY + 1008}

    @image = lg.newImage("assets/water.png")

    @shader = lg.newShader([[
      extern number time;
      extern number size;

      vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
      {
          vec2 p = tc;
          p.x += sin(p.y * size + time) * 0.0005;
          p.y += sin(p.x * size + time) * 0.0005;

          return Texel(tex, p);
      }
    ]])

    @time = 0
    @shader\send("size", 1)
    @shader\send("time", @time)

  update: (dt, cameraX, cameraY) =>
    @time += dt * 5
    @shader\send("size", 10)
    @shader\send("time", @time)

    for i = 1, 4
      if @grid[i].x >= (cameraX - 1280 / 2) + 1790
        @grid[i].x -= 1790 * 2

      if @grid[i].x <= (cameraX - 1280 / 2) - 1790
        @grid[i].x += 1790 * 2

      if @grid[i].y >= (cameraY - 720 / 2) + 1008
        @grid[i].y -= 1008 * 2

      if @grid[i].y <= (cameraY - 720 / 2) - 1008
        @grid[i].y += 1008 * 2

  draw: =>
    lg.setColor(1, 1, 1, 0.9)
    
    lg.setCanvas(@canvas)
    lg.clear!

    for i = 1, 4
      lg.draw(@image, @grid[i].x, @grid[i].y)

    lg.setCanvas!

return Water

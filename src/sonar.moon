objectives = require("objectives")
sfx = require("sfx")

lg = love.graphics

class Sonar
  new: =>
    @r = 64
    @x = lg.getWidth! - (@r * 1.5) - 16
    @y = lg.getHeight! - (@r * 1.5) - 16
    @enemies = nil
    @playerX = nil
    @playerY = nil
    @enemies = {}
    
    @lineX, @lineY = nil, nil
    @theta = 0
    @speed = 3

    @image = lg.newImage("assets/sonar.png")

    @pingTime = true

    @dots = {}

  draw: =>
    lg.setColor(1, 1, 1)
    lg.draw(@image, @x - @image\getWidth!/2, @y - @image\getHeight!/2 - 5)

    lg.setColor(0, 0, 0, .1)
    lg.circle("fill", @x, @y, @r)

    lg.setLineWidth(2)
    lg.setColor(0, .5, 0, .3)
    lg.circle("line", @x, @y, @r)

    lg.setLineWidth(1)
    for i = 1, 4
      lg.circle("line", @x, @y, @r - (@r / 4)*i)

    lg.setColor(0, .5, 0, .8)
    lg.circle("fill", @x, @y, 4)

    for i = 0, 1, 0.2
      lg.setColor(0, 1, 0, 1-i)
      lg.line(@x, @y, @x + @r * math.cos(@theta - i/2), @y + @r * math.sin(@theta - i/2))

    maxDistance = 3000

    for i, v in ipairs(@dots)
      lg.setColor(v.c)
      lg.circle("fill", v.x, v.y, 4*(v.time))

    lg.setColor(1, 1, 1)

    for i, v in ipairs(@enemies)
      alreadyOnSonar = false
      for _, d in ipairs(@dots)
        if d.enemy == v
          alreadyOnSonar = true
          break

      if alreadyOnSonar
        continue

      distance = math.sqrt(((@playerX - v.x) * (@playerX - v.x)) + ((@playerY - v.y) * (@playerY - v.y)))

      if distance > maxDistance
        continue

      c = {}
      if v.objective == objectives.Spy
        c = {0, 0, .5, 1}
      elseif v.objective == objectives.Destroy
        c = {.5, 0, 0, 1}
      elseif v.objective == objectives.Rescue
        c = {0, .5, 0, 1}
      else
        if v.sinking
          continue

        c = {1, 1, 1}

      t = math.atan2(v.y - @playerY, v.x - @playerX)

      -- i literally have no idea what im doing
      if t < 0
        if math.abs(t-@theta+(math.pi*2)) >= 0.05
          continue
      elseif math.abs(t-@theta) >= 0.05
        continue

      r = 0 + (distance - 0) * (@r - 0) / (maxDistance - 0)

      dot = {
        enemy: v,
        c: c,
        x: @x + r * math.cos(t),
        y: @y + r * math.sin(t),
        time: 1
      }

      table.insert(@dots, dot)
        
    lg.setLineWidth(1)

  update: (dt, playerX, playerY, enemies) =>
    @playerX, @playerY = playerX, playerY
    @theta += dt * @speed

    if @theta >= (math.pi * 2)
      @theta = 0
      @pingTime = true

    @enemies = enemies

    if @pingTime and @theta >= math.pi*1.5
      sfx["SONAR"]\stop!
      sfx["SONAR"]\play!
      @pingTime = false

    for i, v in ipairs(@dots)
      v.time -= dt

      if v.time <= 0
        table.remove(@dots, i)

return Sonar

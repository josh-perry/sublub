lg = love.graphics

local paused
local player
local camera
local sonar
local enemies
local bullets
local water

Camera = require("libs.hump.camera")
states = require("states")
objectives = require("objectives")
models = require("models")

lg.setDefaultFilter("nearest", "nearest")

drawWater = ->
  water\draw!
  --lg.setColor(0, 0.47, 0.76, 0.75, 0.75)
  --lg.rectangle("fill", 0, 0, lg\getWidth!*3, lg\getHeight!*3)

love.load = ->
  player = require("player")!
  camera = Camera(player.x, player.y)
 
  dx = player.x - camera.x
  dy = player.y - camera.y

  camera\move(dx, dy)

  water = require("water")(camera.x, camera.y)
  
  paused = false

  maxWidth = lg\getWidth! * 3
  maxHeight = lg\getWidth! * 3

  bullets = {}
  enemies = {}

  for i = 1, 2
    model = models.enemies["assets/ship1"]
    table.insert(enemies, require("Enemy")(model, love.math.random(0, maxWidth), love.math.random(0, maxHeight), objectives.Spy))

  for i = 1, 10
    model = models.enemies["assets/ship2"]
    table.insert(enemies, require("Enemy")(model, love.math.random(0, maxWidth), love.math.random(0, maxHeight), objectives.Spy))
 
  for i = 1, 10
    model = models.enemies["assets/ship3"]
    table.insert(enemies, require("Enemy")(model, love.math.random(0, maxWidth), love.math.random(0, maxHeight), objectives.Destroy))

  sonar = require("sonar")!

viewStencil = ->
  lg.setColor(1, 1, 1)
  lg.circle("fill", lg.getWidth! / 2, lg.getHeight! / 2, player.viewRadius)

love.draw = ->
  if player.state ~= states.Surface
    lg.stencil(viewStencil, "replace")
    lg.setStencilTest("greater", 0)
  
  lg.setShader(water.shader)
  lg.draw(water.canvas)
  lg.setShader!

  camera\attach!

  for i, v in ipairs(bullets)
    v.drawable\drawSurface!

  for i, v in ipairs(enemies)
    v.drawable\drawSurface!

  player.drawable\drawSurface!

  drawWater!

  player.drawable\drawOutline!
  player.drawable\drawUnderwater!

  for i, v in ipairs(bullets)
    v.drawable\drawOutline!
    v.drawable\drawUnderwater!

  for i, v in ipairs(enemies)
    v.drawable\drawOutline!
    v.drawable\drawUnderwater!
   
    lg.setColor(1, 1, 1)
    lg.setLineWidth(3)
    if v.objective == objectives.Spy
      lg.print("SPY", v.x, v.y)
      lg.setColor(0, 0, 1)
    elseif v.objective == objectives.Destroy
      lg.print("DESTROY", v.x, v.y)
      lg.setColor(1, 0, 0)

    if v.objective
      lg.circle("line", v.x, v.y, (math.max(v.drawable.width, v.drawable.height)*v.drawable.scale)/2)

  lg.setLineWidth(1)
  camera\detach!

  lg.setStencilTest()

  sonar\draw!

  lg.setColor(1, 1, 1)
  spyTotal = 0
  destroyTotal = 0

  for i, v in ipairs(enemies)
    if v.objective == objectives.Spy
      spyTotal += 1
    elseif v.objective == objectives.Destroy
      destroyTotal += 1

  lg.print("OBJECTIVES", 10, 10)
  lg.print(string.format("DESTROY %i", destroyTotal), 10, 50)
  lg.print(string.format("SPY %i", spyTotal), 10, 70)

love.update = (dt) ->
  if paused
    return

  player\update(dt, bullets)
  water\update(dt, camera.x, camera.y)

  for i, v in ipairs(enemies)
    v\update(dt)

    distance = math.sqrt(((player.x - v.x) * (player.x - v.x)) + ((player.y - v.y) * (player.y - v.y)))

    if v.objective == objectives.Spy and distance <= 200 and player.state == states.Underwater
      v.objective = nil

  for _, b in ipairs(bullets)
    b\update(dt)

    for _, e in ipairs(enemies)
      distance = math.sqrt(((e.x - b.x) * (e.x - b.x)) + ((e.y - b.y) * (e.y - b.y)))
      
      if distance <= math.max(e.drawable.width, e.drawable.height)
        e.objective = nil

  dx = player.x - camera.x
  dy = player.y - camera.y

  camera\move(dx, dy)

  sonar\update(dt, player.x, player.y, enemies)

love.keypressed = (key) ->
  if key == "escape"
    love.event.quit!
    
  if key == "p"
    paused = not paused

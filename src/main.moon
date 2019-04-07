lg = love.graphics

local paused
local player
local camera
local sonar
local enemies
local bullets
local water
local objUi
local explosions
local musicData
local filterMusicData
local musicSource
local filterMusicSource
local hpOxUi
local hpImg
local oxImg

sone = require("libs.sone")

Camera = require("libs.hump.camera")
states = require("states")
objectives = require("objectives")
ai = require("ai")
models = require("models")
sfx = require("sfx")

lg.setDefaultFilter("nearest", "nearest")

drawWater = ->
  water\draw!

love.load = ->
  love.audio.setVolume(1)
  musicData = love.sound.newSoundData("assets/SUBMARINE_GameplayLoop.wav")
  filterMusicData = musicData\clone!

  sone.filter(filterMusicData, {
    type: "lowpass"
    frequency: 150
  })
  --music = love.audio.newSource("assets/SUBMARINE_GameplayLoop.wav", "stream")
  filterMusicSource = love.audio.newSource(filterMusicData)
  filterMusicSource\setLooping(true)
  filterMusicSource\setVolume(0)
  filterMusicSource\play!
  
  musicSource = love.audio.newSource(musicData)
  musicSource\setLooping(true)
  musicSource\setVolume(1)
  musicSource\play!

  hpOxUi = lg.newImage("assets/HP_OX.png")
  hpImg = lg.newImage("assets/hp.png")
  oxImg = lg.newImage("assets/ox.png")

  lg.setBackgroundColor(1, 1, 1)
  player = require("player")!
  player.x = lg\getWidth! * 1.5
  player.y = lg\getHeight! * 1.5
  
  camera = Camera(player.x, player.y)

  objUi = lg.newImage("assets/Obj_UI.png")
 
  dx = player.x - camera.x
  dy = player.y - camera.y

  camera\move(dx, dy)

  water = require("water")(camera.x, camera.y)
  
  paused = false

  maxWidth = lg\getWidth! * 3
  maxHeight = lg\getWidth! * 3

  bullets = {}
  explosions = {}
  enemies = {}
  
  for i = 1, 3
    model = models.enemies["assets/ship1"]
    table.insert(enemies, require("Enemy")(model, love.math.random(0, maxWidth), love.math.random(0, maxHeight), objectives.Spy, ai.Wander, true))

  for i = 1, 3
    model = models.enemies["assets/ship1B"]
    table.insert(enemies, require("Enemy")(model, love.math.random(0, maxWidth), love.math.random(0, maxHeight), objectives.Spy, ai.Wander, true))

  for i = 1, 3
    model = models.enemies["assets/ship2"]
    table.insert(enemies, require("Enemy")(model, love.math.random(0, maxWidth), love.math.random(0, maxHeight), objectives.Spy, ai.Wander, true))
 
  for i = 1, 3
    model = models.enemies["assets/ship3"]
    table.insert(enemies, require("Enemy")(model, love.math.random(0, maxWidth), love.math.random(0, maxHeight), objectives.Destroy, ai.Wander))

  for i = 1, 3
    model = models.enemies["assets/ship4"]
    table.insert(enemies, require("Enemy")(model, love.math.random(0, maxWidth), love.math.random(0, maxHeight), objectives.Destroy, ai.Wander))

  for i = 1, 3
    model = models["assets/raft"]
    table.insert(enemies, require("Enemy")(model, love.math.random(0, maxWidth), love.math.random(0, maxHeight), objectives.Rescue, nil, false, 0))

  for i = 1, 3
    model = models["assets/raft2"]
    table.insert(enemies, require("Enemy")(model, love.math.random(0, maxWidth), love.math.random(0, maxHeight), objectives.Rescue, nil, false, 0))

  for i, v in ipairs(enemies)
    distance = math.sqrt(((player.x - v.x) * (player.x - v.x)) + ((player.y - v.y) * (player.y - v.y)))

    while distance <= 750
      v.x = love.math.random(0, maxWidth)
      v.y = love.math.random(0, maxHeight)

      distance = math.sqrt(((player.x - v.x) * (player.x - v.x)) + ((player.y - v.y) * (player.y - v.y)))

  sonar = require("sonar")!

viewStencil = ->
  lg.setColor(1, 1, 1)
  lg.circle("fill", lg.getWidth! / 2, lg.getHeight! / 2, player.viewRadius)

love.draw = ->
  if player.dead
    lg.setColor(0, 0, 0)
    lg.rectangle("fill", 0, 0, lg\getWidth!, lg\getHeight!)

    lg.setColor(1, 1, 1)
    lg.printf("you ded", 0, lg\getHeight!/2, lg\getWidth!, "center")
    return

  if player.state ~= states.Surface
    lg.stencil(viewStencil, "replace")
    lg.setStencilTest("greater", 0)

  --lg.setBlendMode("multiply")
--  lg.setShader(water.shader)
 -- lg.setColor(1, 1, 0, 0.3)
  --lg.draw(water.canvas)
  --lg.setShader!
  --lg.setColor(1, 1, 1)
  --lg.setBlendMode("alpha")

  camera\attach!

  for i, v in ipairs(bullets)
    v.drawable\drawSurface!

  for i, v in ipairs(enemies)
    v.drawable\drawSurface!

  player.drawable\drawSurface!

  drawWater!

  camera\detach!
  lg.setShader(water.shader)
  lg.setBlendMode("alpha", "premultiplied")
  lg.setColor(1, 1, 1, 0.9)
  lg.draw(water.canvas)
  lg.setShader!
  lg.setColor(1, 1, 1)
  camera\attach!

  lg.setBlendMode("alpha")

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
      lg.setColor(0, 0, 1)
    elseif v.objective == objectives.Destroy
      lg.setColor(1, 0, 0)
    elseif v.objective == objectives.Rescue
      lg.setColor(0, 1, 0)

    if v.objective
      lg.circle("line", v.x, v.y, (math.max(v.drawable.width, v.drawable.height)*v.drawable.scale)/2)

  for i, v in ipairs(explosions)
    v\draw!

  lg.setLineWidth(1)
  camera\detach!

  lg.setStencilTest()

  sonar\draw!

  lg.setColor(1, 1, 1)
  spyTotal = 0
  destroyTotal = 0
  rescueTotal = 0

  for i, v in ipairs(enemies)
    if v.objective == objectives.Spy
      spyTotal += 1
    elseif v.objective == objectives.Destroy
      destroyTotal += 1
    elseif v.objective == objectives.Rescue
      rescueTotal += 1

  uiY = lg\getHeight! - objUi\getHeight! - 16
  lg.draw(objUi, 16, uiY)
  lg.printf(spyTotal, 16 + 98, uiY + 42 + 7, 23, "center")
  lg.printf(destroyTotal, 16 + 98, uiY + 80 + 7, 23, "center")
  lg.printf(rescueTotal, 16 + 98, uiY + 118 + 7, 23, "center")

  lg.setColor(1, 1, 1)
  hoX = lg\getWidth!/2 - hpOxUi\getWidth!/2
  hoY = lg\getHeight! - 16 - hpOxUi\getHeight!
  lg.draw(hpOxUi, hoX, hoY)
  
  lg.setScissor(hoX + 7, hoY + 37, (player.hp/100)*64, 10)
  lg.draw(hpImg, hoX + 7, hoY + 37)
  lg.setScissor!

  lg.setScissor(hoX + 92, hoY + 37, (player.oxygen/100)*64, 10)
  lg.draw(oxImg, hoX + 92, hoY + 37)
  lg.setScissor!
  --lg.draw(hpOxUi, lg\getWidth!/2, lg\getHeight! - hpOxUi\getHeight! - 16, 1, 1, hpOxUi\getWidth!/2, hpOxUi\getHeight!/2)

love.update = (dt) ->
  if paused
    return

  if player.dead
    return

  player\update(dt, bullets)
  water\update(dt, camera.x, camera.y)

  for i, v in ipairs(enemies)
    if v.z >= 50
      table.remove(enemies, i)

    v\update(dt, bullets, player)

    distance = math.sqrt(((player.x - v.x) * (player.x - v.x)) + ((player.y - v.y) * (player.y - v.y)))

    if v.objective == objectives.Spy and distance <= 200 and player.state == states.Underwater
      if sfx["OBJECTIVECOMPLETE"]\isPlaying!
        sfx["OBJECTIVECOMPLETE"]\clone!\play!
      else
        sfx["OBJECTIVECOMPLETE"]\play!
        
      v.objective = nil

    if v.objective == objectives.Rescue and distance <= 100 and player.state == states.Surface
      v.objectives = nil
      sfx["RAFTRESCUE"]\play!
      table.remove(enemies, i)

  for i, e in ipairs(explosions)
    e\update(dt)

    if e.shrinking and e.drawable.scale <= 0
      table.remove(explosions, i)

  for i, b in ipairs(bullets)
    b\update(dt)

    if not b.playerBullet
      if player.state == states.Underwater
        continue

      distance = math.sqrt(((player.x - b.x) * (player.x - b.x)) + ((player.y - b.y) * (player.y - b.y)))

      if distance <= math.max(player.drawable.width, player.drawable.height)
        player.hp -= 10
        table.remove(bullets, i)

        if player.hp <= 0
          player.dead = true
          filterMusicSource\stop!
          musicSource\stop!

          sfx["FAILURE_wamp"]\play!

          return
        else
          if sfx["EXPLOSION2"]\isPlaying!
            sfx["EXPLOSION2"]\clone!\play!
          else
            sfx["EXPLOSION2"]\play!

          if sfx["FAILURE_ehehhh"]\isPlaying!
            sfx["FAILURE_ehehhh"]\clone!\play!
          else
            sfx["FAILURE_ehehhh"]\play!

      continue

    for _, e in ipairs(enemies)
      distance = math.sqrt(((e.x - b.x) * (e.x - b.x)) + ((e.y - b.y) * (e.y - b.y)))
      
      if distance <= math.max(e.drawable.width, e.drawable.height)

        x = love.math.random(1, 3)

        if sfx["EXPLOSION"..x]\isPlaying!
          sfx["EXPLOSION"..x]\clone!\play!
        else
          sfx["EXPLOSION"..x]\play!

        if e.objective == objectives.Destroy
          if sfx["OBJECTIVECOMPLETE"]\isPlaying!
            sfx["OBJECTIVECOMPLETE"]\clone!\play!
          else
            sfx["OBJECTIVECOMPLETE"]\play!
        else
          if sfx["FAILURE_ehehhh"]\isPlaying!
            sfx["FAILURE_ehehhh"]\clone!\play!
          else
            sfx["FAILURE_ehehhh"]\play!
 
        table.insert(explosions, require("explosion")(e.x, e.y))
        table.remove(bullets, i)
        e.objective = nil
        e.sinking = true

  dx = player.x - camera.x
  dy = player.y - camera.y

  camera\move(dx, dy)

  sonar\update(dt, player.x, player.y, enemies)

  if player.state == states.Underwater
    filterMusicSource\setVolume(1)
    musicSource\setVolume(0)
  else
    filterMusicSource\setVolume(0)
    musicSource\setVolume(1)

love.keypressed = (key) ->
  if key == "escape"
    love.event.quit!
    
  if key == "p"
    paused = not paused

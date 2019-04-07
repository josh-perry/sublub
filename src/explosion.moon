lg = love.graphics
models = require("models")

class Explosion
  new: (x, y) =>
    model = models["assets/explosion"]
    @drawable = require("Drawable")(model, 1)

    @x = x
    @y = y
    @z = 0

    @drawable\updatePosition(@x, @y, @z)
    @shrinking = false
    @sprite = lg.newImage("assets/explosion.png")
    @quad = {}

    for i=1,4
	   	@quad[i] = love.graphics.newQuad(-15 + 15 * i, 0, 15, 15, @sprite\getDimensions())

    @particle = love.graphics.newParticleSystem(@sprite,1000)
    @particle\setQuads(@quad[1], @quad[2], @quad[3], @quad[4])
    @particle\setEmissionArea("normal", 10, 10)
    @particle\setEmitterLifetime(0.6)
    @particle\setEmissionRate(500)
    @particle\setParticleLifetime(0.8,1.5)
    @particle\setDirection(-math.pi / 2)
    @particle\setSpread (math.pi * 2)
    @particle\setSpeed(15, 150 )
    @particle\setSizes(2,3)
    @particle\setSizeVariation(1)
    @particle\setRotation(0)
    @particle\setSpin(3, 0)
    @particle\setSpinVariation(1)
    @particle\setColors(1,1,1,1, 1,0.67,0.2,1, 1,0.91,0.38,1, 0.78,0.29,0.18,1, 0.24,0.15,0.18,1, 0.1,0.06,0.15,1, 0,0,0,0)
    @particle\setPosition(@x, @y)

  update: (dt) =>
    @particle\update(dt)

  draw: =>
		lg.setColor(1, 1, 1)
		lg.draw(@particle, 0, 0)

return Explosion

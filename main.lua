require 'src/Dependencies'

VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 84, 48
WINDOW_WIDTH, WINDOW_HEIGHT = 1260, 720
COLOR_DARK  = { 67/255,  82/255,  61/255, 1}
COLOR_LIGHT = {215/255, 240/255, 232/255, 1}
FPS_LIMIT = 15
FPS_FRAME_DURATION = 1/FPS_LIMIT
fpsTimer = 0

globalX, globalY = 70, 118

background = love.graphics.newImage('assets/sideA.png')
tvLight = LightSource(110, 160, 40, {.5,.6,.7,.8,.9})
tvLight:enableAnimation(40,60,0.25)

function love.load()
    love.window.setTitle('Nokia 3310')
    love.graphics.setDefaultFilter('nearest','nearest')
    push:setupScreen(
        VIRTUAL_WIDTH, VIRTUAL_HEIGHT,
        WINDOW_WIDTH, WINDOW_HEIGHT,
        {
            vsync = true,
            resizable = true,
            fullscreen = false,
        }
    )
end

function love.update(dt)
    fpsTimer = fpsTimer + dt
    if fpsTimer > FPS_FRAME_DURATION then
        fpsTimer = fpsTimer - FPS_FRAME_DURATION
    end

    tvLight:update(dt)
end

function love.draw()
    push:start()

    love.graphics.setColor(COLOR_DARK)
    love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH,VIRTUAL_WIDTH)
    tvLight:render()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(background, -globalX, -globalY)

    push:finish()
end

function love.resize(width, height)
    push:resize(width, height)
end
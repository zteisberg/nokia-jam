require 'src/Dependencies'

VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 84, 48
WINDOW_WIDTH, WINDOW_HEIGHT = 630, 360
COLOR_DARK  = { 67/255,  82/255,  61/255}
COLOR_LIGHT = {199/255, 240/255, 216/255}
FPS_LIMIT = 15
FPS_FRAME_DURATION = 1/FPS_LIMIT
fpsTimer = 0

globalX, globalY = 70, 118  -- Used to position all "globally positioned" objects relative to camera

Sprites:Load()

local toggleDebug = false
local gx,gy = 0,0

background = love.graphics.newImage('assets/sideA.png')
tvLight = LightSource(110, 172, 70, {.5,.6,.7,.8,.9})
tvLight:enableAnimation(50,70,2)
tvLight:setAngle(math.pi /8, math.pi *6/8)
tv = Objects('TV',96,155, true)
dad = Dad(40, 45, true, false)

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
    love.keyboard.keysPressed = {
        ['a'] = false,
        ['d'] = false,
    }
end

function love.update(dt)
    fpsTimer = fpsTimer + dt
    if fpsTimer > FPS_FRAME_DURATION then
        fpsTimer = fpsTimer - FPS_FRAME_DURATION
        tvLight:update()
        tv:update()
        dad:update()
    end

end

function lights()
    tvLight:render()
    if toggleDebug then
        love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH,VIRTUAL_HEIGHT)
    end
end

function love.draw()
    push:start()

    -- Draw darkness first
    love.graphics.setColor(COLOR_DARK)
    love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH,VIRTUAL_WIDTH)

    -- Draw lights and use them as a mask
    love.graphics.setColor(COLOR_LIGHT)
    lights()
    love.graphics.stencil(lights, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    -- Draw background, objects, and characters
    love.graphics.setColor(1,1,1)
    love.graphics.draw(background, -globalX, -globalY)
    dad:render()
    tv:render()

    -- Clear mask
    love.graphics.setStencilTest()


    push:finish()
end

function love.resize(width, height)
    push:resize(width, height)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key=='f5' then
        toggleDebug = not toggleDebug
        if toggleDebug then
             gx, gy = globalX, globalY
             globalX, globalY = 0,0
             VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 210,168
        else
            globalX, globalY = gx, gy
            VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 84,48
        end
        push:setupScreen(
            VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
            { vsync = true, resizable = true, fullscreen = false }
        )
    end
end

function love.keyreleased(key)
    love.keyboard.keysPressed[key] = false
end

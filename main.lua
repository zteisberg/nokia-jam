require 'src/Dependencies'

VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 84, 48
WINDOW_WIDTH, WINDOW_HEIGHT = 630, 360
COLOR_DARK  = { 67/255,  82/255,  61/255}
COLOR_LIGHT = {199/255, 240/255, 216/255}
FPS_LIMIT = 15
FPS_FRAME_DURATION = 1/FPS_LIMIT
fpsTimer = 0

globalX, globalY = 70, 118  -- Used to position all "globally positioned" objects
cameraX, cameraY = 0, 0     -- Used to offset all "locally positioned" objects

Sprites:Load()

background = love.graphics.newImage('assets/sideA.png')
tvLight = LightSource(110, 172, 70, {.5,.6,.7,.8,.9})
tvLight:enableAnimation(50,70,2)
tvLight:setAngle(math.pi /8, math.pi *6/8)
tv = Entity(90,140)
tv:setAnimation(nil)
tv:setSprite(sprites["SideA_TV"])


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
        dad:update()
    end

end

local function lights()
    tvLight:render()
    love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH,VIRTUAL_HEIGHT)
end

function love.draw()
    push:start()

    -- Draw darkness first
    love.graphics.setColor(COLOR_DARK)
    love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH,VIRTUAL_WIDTH)

    -- Draw lights and use them as a mask
    lights()
    love.graphics.setColor(COLOR_LIGHT)
    love.graphics.stencil(lights, "replace", 1)
    love.graphics.setColor(1,1,1)
    love.graphics.setStencilTest("greater", 0)

    -- Draw background, objects, and characters
    love.graphics.draw(background, -globalX, -globalY)
    dad:render()
    -- tv:render()

    -- Clear mask
    love.graphics.setStencilTest()


    push:finish()
end

function love.resize(width, height)
    push:resize(width, height)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyreleased(key)
    love.keyboard.keysPressed[key] = false
end

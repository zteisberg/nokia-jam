require 'src/Dependencies'

VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 84, 48
WINDOW_WIDTH, WINDOW_HEIGHT = 420, 240
COLOR_DARK  = { 67/255,  82/255,  61/255}
COLOR_LIGHT = {199/255, 240/255, 216/255}


FPS_LIMIT = 15
FPS_FRAME_DURATION = 1/FPS_LIMIT
fpsTimer = 0

CAMERA_SPEED = 12
CAMERA_MARGIN = {x=3, y=3}         --
camera = {x=-70, y=-117}  -- Used to position all "relatively positioned" with respect to camera
local gx,gy = 0,0


Sprites:Load()

local toggleDebug = false
local toggleLight = false

background = love.graphics.newImage('assets/sideA.png')
tvLight = LightSource(110, 172, 50, {.5,.6,.7,.8,.85,.9}, math.pi *6/8, math.pi /8)
tvLight:setAnimation(50,70,1)
flashlight = LightSource(0,0,80, {.4,.475,.55,.625,.7,.775}, math.pi /4, math.pi /-8)
flashlight.relative = false
tv = Objects('TV',112,150)
dad = Dad(40, 45, true, false)

maskShader = love.graphics.newShader[[
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
       if (Texel(texture, texture_coords).a == 0) {
          discard;
       }
       return vec4(0.0);
    }
]]

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
        ['s'] = false,
        ['d'] = false,
        ['w'] = false,
        ['q'] = false,
        ['e'] = false,
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

function mask()
    if not toggleLight then
        -- tvLight:render()
        flashlight:render()
    else love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH,VIRTUAL_HEIGHT) end

    love.graphics.setShader(maskShader)
    dad:render()
    love.graphics.setShader()
end

function love.draw()
    push:start()

    -- Draw darkness first
    love.graphics.setColor(COLOR_DARK)
    love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH,VIRTUAL_WIDTH)

    -- Draw lights and use them as a mask
    love.graphics.setColor(COLOR_LIGHT)
    love.graphics.stencil(mask, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    -- Draw background, objects, and characters
    love.graphics.setColor(1,1,1)
    love.graphics.draw(background, math.floor(camera.x), math.floor(camera.y))
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
            dad.x = dad.x + camera.x
            dad.y = dad.y + camera.y
            gx, gy = camera.x, camera.y
            camera.x, camera.y = 0,0
            WINDOW_WIDTH, WINDOW_HEIGHT = 1260, 720
            VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 210,168
        else
            camera.x, camera.y = gx, gy
            dad.x = dad.x - camera.x
            dad.y = dad.y - camera.y
            WINDOW_WIDTH, WINDOW_HEIGHT = 630, 360
            VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 84,48
        end
        push:setupScreen(
            VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
            { vsync = true, resizable = true, fullscreen = false }
        )
    end
    if key=='f6' then
        toggleLight = not toggleLight
    end
end

function love.keyreleased(key)
    love.keyboard.keysPressed[key] = false
end

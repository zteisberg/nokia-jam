require 'src/Dependencies'

VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 84, 48
WINDOW_WIDTH, WINDOW_HEIGHT = 630, 360
COLOR_DARK  = { 67/255,  82/255,  61/255}
COLOR_LIGHT = {199/255, 240/255, 216/255}
FPS_LIMIT = 15
FPS_FRAME_DURATION = 1/FPS_LIMIT
fpsTimer = 0

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

    Graphics:Load()
    input = Input({'wasdqezxc123'})

    gameObjects = {}
    gameObjects['camera'] = Camera(70, 117, 12, 3, 3)
    gameObjects['dad'] = Dad(110, 161, true, false)
    gameObjects['tv'] = Objects('TV', 96, 155)

    player = gameObjects['dad']
    camera = gameObjects['camera'].pos
    background = love.graphics.newImage('assets/sideA.png')

    obstructions = {}
    -- obstructions['bathroomDoorSideA'] = Obstruction(90,135,10,10)

    lightSources = {}
    lightSources['tvLight'] = LightSource(110, 172, 50, {.5,.6,.7,.8,.85,.9})
    lightSources['tvLight']:setAngle(math.pi *6/8, math.pi /8)
    lightSources['tvLight']:setAnimation(50, 70)
    lightSources['tvLight'].visible = false
    lightSources['flashlight'] = Flashlight(math.pi*2)

    
    maskShader = love.graphics.newShader[[
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
        if (Texel(texture, texture_coords).a == 0) {
            discard;
        }
        return vec4(0.0);
    }]]
end

function love.update(dt)
    fpsTimer = fpsTimer + dt
    if fpsTimer > FPS_FRAME_DURATION then
        updateGame()
        fpsTimer = fpsTimer - FPS_FRAME_DURATION
    end
    
end

function updateGame()
    input:update()
    for key, obj in pairs(gameObjects)    do obj  :update() end
    for key, light in pairs(lightSources) do light:update() end

end

function lights()
    if not input.toggleLight then
        for key, light in pairs(lightSources) do
            light:render()
        end
    else love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH,VIRTUAL_HEIGHT) end

    love.graphics.setShader(maskShader)
    player:render()
    love.graphics.setShader()
end

function shadows()
    if not input.toggleLight then
        for i, light in pairs(lightSources) do
            if light.visible then
                for k, obstruction in pairs(obstructions) do
                    light:shadows()
                end
            end
        end
    end
end

function love.draw()
    push:start()

    -- Draw darkness first
    love.graphics.setColor(COLOR_DARK)
    love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH,VIRTUAL_WIDTH)

    -- Draw lights and use them as a mask
    love.graphics.setColor(COLOR_LIGHT)
    love.graphics.stencil(lights, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    -- Draw background, objects, and characters
    love.graphics.setColor(1,1,1)
    love.graphics.draw(background, -math.floor(camera.x), -math.floor(camera.y))
    for key, obj in pairs(gameObjects) do obj:render() end


    -- Draw shadows next
    love.graphics.setColor(COLOR_DARK)
    for key, obs in pairs(obstructions) do obs:render() end
    love.graphics.stencil(shadows, "replace", 1)
    love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH,VIRTUAL_WIDTH)

    -- Clear mask
    love.graphics.setStencilTest()


    push:finish()
end

function love.resize(width, height)
    push:resize(width, height)
end
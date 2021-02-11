require 'src/Dependencies'

function love.load()

    VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 84, 48
    WINDOW_WIDTH, WINDOW_HEIGHT = 630, 360
    COLOR_DARK  = { 67/255,  82/255,  61/255}
    COLOR_LIGHT = {199/255, 240/255, 216/255}
    FPS_LIMIT = 15
    FPS_FRAME_DURATION = 1/FPS_LIMIT
    fpsTimer = 0
    currentFrameCycle = 0

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
    local points = {}
    for i = 0, 1000 do
        points[#points+1] = {
            love.math.random(21) - 10,
            love.math.random(21) - 10,
        }
    end
    local test = Raycaster({points})
    test:sortByAngle({0,0})
    
    Graphics:Load()
    SoundSystem:Load()
    LightSource:Load()
    input = Input()
    state = StateHandler()
    state:addState('play', function() return PlayState() end, true)
    state:setState('play')
end

function love.update(dt)
    fpsTimer = fpsTimer + dt
    currentFrameCycle = (currentFrameCycle + 1) % FPS_LIMIT
    if fpsTimer > FPS_FRAME_DURATION then
        updateGame()
        fpsTimer = fpsTimer - FPS_FRAME_DURATION
    end
end

function updateGame()
    state:update()
    input:update()
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
    state:render()
    push:finish()
end

function love.resize(width, height)
    push:resize(width, height)
end
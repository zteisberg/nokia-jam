require 'src/Dependencies'

function love.load()

    ZOOM_LEVEL = 1.5
    VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 84 * ZOOM_LEVEL, 48 * ZOOM_LEVEL
    WINDOW_WIDTH, WINDOW_HEIGHT = 630, 360
    COLOR_DARK  = { 67/255,  82/255,  61/255, 1}
    COLOR_LIGHT = {199/255, 240/255, 216/255, 1}
    FPS_LIMIT = 15
    FPS_FRAME_DURATION = 1/FPS_LIMIT
    fpsTimer = 0
    currentFrameCycle = 0

    love.window.setTitle('Nokia 3310')
    love.graphics.setDefaultFilter('nearest','nearest')
    love.graphics.setLineWidth(1)
    love.graphics.setLineStyle('rough')
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
    SoundSystem:Load()
    LightSource:Load()
    Interactable:Load()
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
        SoundSystem.update()
        fpsTimer = fpsTimer - FPS_FRAME_DURATION
    end
end

function updateGame()
    state:update()
    input:update()
end

function love.draw()
    push:start()
    state:render()
    push:finish()
end

function love.resize(width, height)
    push:resize(width, height)
end
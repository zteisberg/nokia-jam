PlayState = Class{__includes = BaseState}

-- Throws out transparent pixels so that they won't be included in the stencil
local ALPHA_HANDLER = love.graphics.newShader[[
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
        if (Texel(texture, texture_coords).a == 0) {
            discard;
        }
        return vec4(0.0);
    }
]]

local ui = {}
local gameObjects = {}
local lightSources = {}
local walls = {}

-- Raycasting variables
local shadows = nil
local playerView = nil
local nextSource = nil
local visibleSources = 0
local renderedSources = 0

function PlayState:init()
    gameObjects['camera'] = Camera(70, 117, 12, 3, 4)
    gameObjects['dad'] = Dad(110, 161)
    gameObjects['tv'] = Objects('TV', 96, 155)
    gameObjects['railing'] = Objects('Stairway_Railing', 120, 100)
    gameObjects['railing'].visible = false

    ui['battery'] = Battery(1, 1)
    ui['bathroomDoor'] = Interactable(58, 125, 'button')
    ui['sideA-stairArrowUp'] = Interactable(162, 125, 'up-arrow', 40, 'w', PlayState.playerEnterOrExitStairs, 'enter')
    ui['sideA-stairArrowDown'] = Interactable(162, 125, 'down-arrow', 40, 's', PlayState.playerEnterOrExitStairs, 'exit')
    ui['sideA-stairArrowDown'].isActive = false
    ui['sideA-stairArrowDown'].keyDownIsOkay = true
    ui['sideA-stairDescend'] = Interactable(140, 90, 'right-arrow', 28, 'd', PlayState.playerDescendStairs, nil, 3)
    ui['sideA-stairDescend'].keyDownIsOkay = true
    ui['sideA-stairDescend'].viewableRadius = 50^2

    player = gameObjects['dad']
    camera = gameObjects['camera']
    background = love.graphics.newImage('assets/sideA.png')

    lightSources['tvLight'] = LightSource(60, 165, 50, .4)
    lightSources['tvLight']:setAngle(math.pi *6/8, math.pi /8)
    lightSources['tvLight']:setAnimation(50, 70)
    lightSources['tvLight'].offset = {x=50, y=7}
    lightSources['flashlight'] = Flashlight(math.pi/3, 100)
    lightSources['headlight'] = LightSource(-100,-100,20, {.7, .03})
    -- lightSources['tvLight'].visible = false
    -- lightSources['headlight'].visible = false

    walls = {{{x=5,y=58}, {x=175,y=58}, {x=175,y=166}, {x=5,y=166}}}
    walls[#walls + 1] = {{x=5,y=112}, {x=123,y=112}}
    walls[#walls + 1] = {{x=90,y=58}, {x=90,y=112}}
    walls[#walls + 1] = {{x=58,y=112}, {x=58, y=132}}
    walls["door"] = {{x=58,y=112}, {x=58,y=166}}
    shadows = Raycaster(walls)
    playerView = Raycaster(walls)
end

function PlayState:enter(parameters)
end

function PlayState:update()
    self:handleInput()
    for key, element in pairs(ui)         do element:update() end
    for key, obj in pairs(gameObjects)    do obj:update() end
    for key, light in pairs(lightSources) do light:update() end
    if lightSources['flashlight'].visible then
        ui['battery'].charge = math.max(ui['battery'].charge - 0.01, 0)
        if ui['battery'].charge <= 0 then
            lightSources['flashlight'].visible = false
        end
    end
    lightSources['headlight'].pos = {
        x = player.pos.x + 2 * player.direction,
        y = player.pos.y - 22
    }
    if player.state == 'stairs' then
        lightSources['headlight'].pos.x = lightSources['headlight'].pos.x - player:getFlashlightX() + 3 + 8 * (player.animation == player.animations['stairsUpFL'] and 1 or -1)
        lightSources['headlight'].pos.y = lightSources['headlight'].pos.y - player:getFlashlightY() + 14 + 5 * (player.animation == player.animations['stairsUpFL'] and 1 or -1)
    end
    lightSources['headlight'].direction = player.direction
    lightSources['headlight']:adjustRadius( - 0.01 )
end

function PlayState:render()

    -- Draw darkness first
    love.graphics.setColor(COLOR_DARK)
    love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH,VIRTUAL_WIDTH)

    -- Render mask using light sources and raytracing
    self:renderMask()
    
    -- Draw background, objects, and characters
    love.graphics.setColor(1,1,1)
    love.graphics.draw(background, -math.floor(camera.pos.x), -math.floor(camera.pos.y))
    for i in pairs(gameObjects) do gameObjects[i]:render() end

    -- Clear mask and draw UI
    love.graphics.setStencilTest()
    for i in pairs(ui) do ui[i]:render() end
    if toggleDebug then shadows:render(lightSources['flashlight'].pos) end
end

function PlayState:fill()
    love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH,VIRTUAL_HEIGHT)
end

function PlayState:renderMask()
    visibleSources = 0
    renderedSources = 0
    for i, light in pairs(lightSources) do
        if light.visible then visibleSources = visibleSources + 1 end
    end


    love.graphics.setColor(1,1,1)
    love.graphics.stencil(self.fill, "replace", 0)

    for i, light in pairs(lightSources) do
        if light.visible then
            nextSource = light
            love.graphics.stencil(self.renderNext, 'increment', 1, true)
            love.graphics.stencil(self.fill, 'decrement', 1, true)
            love.graphics.stencil(self.fill, 'decrement', 1, true)
            local rerenders = visibleSources - renderedSources - 1
            if rerenders > 0 then
                for i = 1, rerenders do
                    love.graphics.stencil(self.rerenderNext, 'increment', 1, true)
                    love.graphics.stencil(self.fill, 'decrement', 1, true)
                    love.graphics.stencil(self.fill, 'decrement', 1, true)
                end
                renderedSources = renderedSources + 1
            end
        end
    end

    love.graphics.stencil(self.subvertMask, 'replace', 1, true)
    if toggleLight then love.graphics.stencil(self.fill, 'replace', 1) end
    love.graphics.setStencilTest("greater", 0)
end
    
function PlayState:renderNext()
    nextSource:render()
    shadows:render(nextSource.pos)
    playerView:render({x=player.pos.x, y=player.pos.y-22})
end

function PlayState:rerenderNext()
    nextSource:rerender()
    shadows:rerender(nextSource.pos)
    playerView:rerender({x=player.pos.x, y=player.pos.y-22})
end

function PlayState:subvertMask()
    -- Exclude player from mask. Shader filters out transparent pixels from image file.
    love.graphics.setShader(ALPHA_HANDLER)
    player:render()
    love.graphics.setShader()
end

function PlayState:handleInput()
    if player.state == 'idle' or player.state == 'walking' then
        local moveDirection = 0
        player.animation.reverse = false

        if not input.keysDown['a'] and not input.keysDown['d'] then player:setIdle()
        elseif input.keysDown['a'] or input.keysDown['d'] then player:setWalk()
            if input.keysDownDuration['a'] > input.keysDownDuration['d'] then
                 moveDirection = -1
            else moveDirection = 1 end
            if input.keysDown['a'] and input.keysDown['d'] then
                moveDirection = moveDirection * -1
            end
            if player.direction ~= moveDirection then
                 camera.pos.x = camera.pos.x + moveDirection * 2
                 player.animation.reverse = true
            end
            player.pos.x = player.pos.x + moveDirection
        end

        if     input.keysPressed['a'] and not input.keysDown['d'] then player.direction = -1
        elseif input.keysPressed['d'] and not input.keysDown['a'] then player.direction = 1 end

        if     input.keysReleased['a'] and input.keysDown['d'] then player.direction = 1
        elseif input.keysReleased['d'] and input.keysDown['a'] then player.direction = -1 end
    end

    if player.state == 'idle' or player.state == 'walking' or player.state == 'stairsEntrance' then
        if (input.keysDownDuration['q'] + input.keysDownDuration['e']) % math.floor(FPS_LIMIT*.5) == 1 then
            local turnDirection =  -1
            if input.keysDownDuration['q'] > input.keysDownDuration['e'] then turnDirection = 1 end
            
            local angle = player.angle + math.pi/4 * player.direction * turnDirection
            if angle > math.pi/2  or angle < 0 then
                 player.direction = player.direction *-1
                 camera.center = true
            else player.angle = angle end
    
            SoundSystem.play("interact") 
        end
    end

    -- Handle input for stairs
    if 'stairs' == string.sub(player.state,1,6) then
        local traverse = ''
        if     input.keysDown['w'] then traverse = 'up'
        elseif input.keysDown['s'] then traverse = 'down'
        elseif input.keysDown['a'] then traverse = (player.stairDirection == 1 and 'down' or 'up')
        elseif input.keysDown['d'] then traverse = (player.stairDirection == 1 and 'up' or 'down')
        end

        if player.state == 'stairsEntrance' then
            if traverse == 'up' then
                player:setStairsUp()
                player.animation.frame = 0
                player.pos.x = player.pos.x + 6 * player.stairDirection
            elseif traverse == 'down' then
                player.direction = -player.stairDirection
            end
        elseif traverse ~= '' then
            local inverseFrameCount = #player.animation.cycle - player.animation.frame
            if traverse == 'up' and player.animation == player.animations['stairsDownFL'] then
                player:setStairsUp()
                player.animation.frame = inverseFrameCount
            elseif traverse == 'down' and player.animation == player.animations['stairsUpFL'] then
                player:setStairsDown()
                player.animation.frame = inverseFrameCount
            end

            player.animation.frame = player.animation.frame + 0.4
            if player.animation:getFrame() % 3 == 0 then
                SoundSystem.playIfQuiet('interact')
            end
        end

    end
    
    if (input.keysPressed['space']) and ui["battery"].charge > 0 then
        SoundSystem.play("turn_on_flashlight")
        lightSources['flashlight'].visible = not lightSources['flashlight'].visible
    end

    if input.keysPressed['f5'] then toggleLight = not toggleLight end
    if input.keysPressed['f6'] then toggleDebug = not toggleDebug end
    if input.keysPressed['f7'] then toggleMouse = not toggleMouse end
    if input.keysDown['left'] then
        for i, pt in pairs(walls['door']) do
            pt.x = pt.x - 5
        end
    end
    if input.keysDown['right'] then
        for i, pt in pairs(walls['door']) do
            pt.x = pt.x + 5
        end
    end
end

function PlayState:playerEnterOrExitStairs(mode)
    if mode == 'enter' then
        if player.state ~= 'idle' and player.state ~= 'walking' then
            self.isActive = true
            goto exit_function
        end
        player.direction = -1
        player.pos.y = player.pos.y - 3
        player.state = 'enterStairs'
        player.animation = player.animations['stairsEnter']
        player.flashlightOffset = player.offset['stairsEnter']
        SoundSystem.queue('open_door')
    elseif mode == 'exit' then
        if player.state ~= 'stairsEntrance' then
            self.isActive = true
            goto exit_function
        end
        player.direction = 1
        player.pos.y = player.pos.y + 9
        player.state = 'exitStairs'
        player.animation = player.animations['stairsExitFL']
        player.flashlightOffset = player.offset['stairsExit']
        gameObjects['railing'].visible = false
        SoundSystem.queue('close_door')
    end

    self.resetTime = -1
    camera.center = true
    player.angle = 0
    player.animation.frame = 0
    player.pos.x = self.pos.x

    local radius = lightSources['flashlight'].radius
    local angle = lightSources['flashlight'].angle
    local falloff = lightSources['flashlight'].falloff[1]
    lightSources['flashlight'].radius = 40
    lightSources['flashlight']:setAngle(math.pi*2)
    lightSources['flashlight']:setFalloff(0.7,0.03)

    player.animation.callback = function()
        player.direction = -1
        lightSources['flashlight'].radius = radius
        lightSources['flashlight']:setAngle(angle)
        lightSources['flashlight']:setFalloff(falloff)

        local queueNext = 'sideA-stairArrowDown'

        if mode == 'enter' then
            player:setStairsEntrance()
            player.stairDirection = -1
            player.pos.y = player.pos.y - 6
            player.angle = math.pi/4
            gameObjects['railing'].visible = true
        elseif mode == 'exit' then
            player:setIdle()
            player.angle = 0
            queueNext = 'sideA-stairArrowUp'
        end
        
        ui[queueNext].resetTime = 3
        ui[queueNext].resetTimer = 0
    end

    ::exit_function::
end

function PlayState:playerDescendStairs()
    player.pos.x = self.pos.x + 15
    player.pos.y = self.pos.y + 62
    player:setStairsDown()
    player.animation.frame = 0
    player.stairDirection = -1
    player.direction = -1
end
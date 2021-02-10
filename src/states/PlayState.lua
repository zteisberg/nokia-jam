PlayState = Class{__includes = BaseState}

local ui = {}
local gameObjects = {}
local obstructions = {}
local lightSources = {}
local alphaHandler = love.graphics.newShader[[
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
        if (Texel(texture, texture_coords).a == 0) {
            discard;
        }
        return vec4(0.0);
    }]]

function PlayState:init()
    gameObjects['camera'] = Camera(70, 117, 12, 3, 3)
    gameObjects['dad'] = Dad(110, 161, true, false)
    gameObjects['tv'] = Objects('TV', 96, 155)

    ui['battery'] = Battery(1, 1, true, false)
    ui['doorButton'] = Button(60, 125, true, true)
    ui['stairsArrow'] = Arrow(160, 125, true, true)

    player = gameObjects['dad']
    camera = gameObjects['camera']
    background = love.graphics.newImage('assets/sideA.png')

    -- obstructions['bathroomDoorSideA'] = Obstruction(90,135,10,10)

    lightSources['tvLight'] = LightSource(110, 172, 50, {.5,.6,.7,.8,.85,.9})
    lightSources['tvLight']:setAngle(math.pi *6/8, math.pi /8)
    lightSources['tvLight']:setAnimation(50, 70)
    -- lightSources['tvLight'].visible = false
    lightSources['flashlight'] = Flashlight(math.pi/3, 80)
    lightSources['headlight'] = LightSource(-100,-100,20, {.5,.6,.7,.8,.9})
end

function PlayState:enter(parameters)
end

function PlayState:update()
    for key, obj in pairs(gameObjects)    do obj  :update() end
    for key, light in pairs(lightSources) do light:update() end
    if lightSources['flashlight'].visible then
        ui['battery'].charge = math.max(ui['battery'].charge - 0.01, 0)
        if ui['battery'].charge <= 0 then
            lightSources['flashlight'].visible = false
        end
    end
    lightSources['headlight'].pos = {
        x = player.pos.x + 1 * player.direction,
        y = player.pos.y - 22
    }
    lightSources['headlight']:setRadius(lightSources['headlight'].radius - 0.01)
    self:handleInput()
end

function PlayState:render()

    -- Draw darkness first
    love.graphics.setColor(COLOR_DARK)
    love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH,VIRTUAL_WIDTH)

    -- Draw lights and use them as a mask
    love.graphics.setColor(COLOR_LIGHT)
    love.graphics.stencil(self.lights, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    -- Draw background, objects, and characters
    love.graphics.setColor(1,1,1)
    love.graphics.draw(background, -math.floor(camera.pos.x), -math.floor(camera.pos.y))
    for i in pairs(gameObjects) do gameObjects[i]:render() end
    for i in pairs(ui) do ui[i]:render() end


    -- Draw shadows next
    love.graphics.setColor(COLOR_DARK)
    for key, obs in pairs(obstructions) do obs:render() end
    love.graphics.stencil(self.shadows, "replace", 1)
    love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH,VIRTUAL_WIDTH)

    -- Clear mask
    love.graphics.setStencilTest()
end

function PlayState:shadows()
    for j in pairs(obstructions) do
        lightSources['flashlight']:shadows(obstructions[j])
    end
end

function PlayState:lights()
    if not toggleLight then
        for key, light in pairs(lightSources) do
            light:render()
        end
    else love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH,VIRTUAL_HEIGHT) end
    
    -- UI_elements
    love.graphics.setShader(alphaHandler)
    for element in pairs(ui) do ui[element]:render() end
    player:render()
    love.graphics.setShader()
end

function PlayState:handleInput()
    if player.state ~= 'stairs' then
        local moveDirection = 0

        if     input.keysDown['a'] == input.keysDown['d'] then player:setIdle()
        elseif input.keysDown['a'] or input.keysDown['d'] then player:setWalk()
            if input.keysDown['a'] then moveDirection = -1 end
            if input.keysDown['d'] then moveDirection = 1 end
            if player.direction ~= moveDirection then
                 camera.pos.x = camera.pos.x + moveDirection * 2
                 player.animation.reverse = true
            else player.animation.reverse = false end
            player.pos.x = player.pos.x + moveDirection
        end

        if     input.keysPressed['a'] and not input.keysDown['d'] then player.direction = -1
        elseif input.keysPressed['d'] and not input.keysDown['a'] then player.direction = 1 end

        if     input.keysReleased['a'] and input.keysDown['d'] then player.direction = 1
        elseif input.keysReleased['d'] and input.keysDown['a'] then player.direction = -1 end
    end
    
    if (input.keysPressed['space']) and ui["battery"].charge > 0 then
        lightSources['flashlight'].visible = not lightSources['flashlight'].visible
    end

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

    if input.keysPressed['w'] then player:setStairsUp() end
    if input.keysPressed['f5'] then toggleLight = not toggleLight end
    if input.keysPressed['f6'] then toggleDebug = not toggleDebug end
end
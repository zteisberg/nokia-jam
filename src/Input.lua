Input = Class{}

function Input:init()
    self.toggleLight = false
    self.toggleDebug = false
    self.keysPressed = {
        ['a'] = false,
        ['s'] = false,
        ['d'] = false,
        ['w'] = false,
        ['q'] = false,
        ['e'] = false,
        ['f5'] = false,
        ['f6'] = false,
        ['space'] = false,
    }
    self.keysTimer = {}
    self.keysDown = {}
    for key in pairs(self.keysPressed) do
        self.keysDown[key] = false
        self.keysTimer[key] = 0
    end
end

function Input:update()
    local camera = gameObjects['camera']

    if self.keysDown['a'] and self.keysDown['d'] or
        self.keysDown['a'] == self.keysDown['d'] then
        player:setIdle()
        
    else
        player:setWalk()
        if     self.keysDown['a'] then player.direction = -1
        elseif self.keysDown['d'] then player.direction = 1
        end
    end
    
    if (self.keysDown['space']) == 1 and gameObjects["battery"].charge > 0 then
        lightSources['flashlight'].visible = not lightSources['flashlight'].visible
    end

    if (self.keysTimer['q'] + self.keysTimer['e']) % math.floor(FPS_LIMIT*.5) == 1 then
        SoundSystem.play("interact")
        local turnDirection =  -1
        if self.keysTimer['q'] > self.keysTimer['e'] then turnDirection = 1 end
        
        local angle = player.angle + math.pi/4 * player.direction * turnDirection
        if math.abs(angle) > math.pi/2 then
            if player.state == 'idle' then
                player.direction = player.direction *-1
                camera.center = true
            end
        else player.angle = angle end     
    end

    if self.keysPressed['f5'] then self.toggleLight = not self.toggleLight end
    if self.keysPressed['f6'] then self.toggleDebug = not self.toggleDebug end

    for key in pairs(self.keysPressed) do self.keysPressed[key] = false end
    for key in pairs(self.keysTimer) do
        if self.keysTimer[key] > 0 then 
            self.keysTimer[key] = self.keysTimer[key] + 1
            self.keysDown[key] = true
        else self.keysDown[key] = false
        end
    end
end

function love.keypressed(key)
    input.keysPressed[key] = true
    input.keysTimer[key] = 1
end

function love.keyreleased(key)
    input.keysTimer[key] = 0
end

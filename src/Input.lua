Input = Class{}

function Input:init()
    self.keysPressed = {
        ['a'] = false,
        ['s'] = false,
        ['d'] = false,
        ['w'] = false,
        ['q'] = false,
        ['e'] = false,
        ['f5'] = false,
        ['f6'] = false,
    }
    self.keysDown = {}
    for key in pairs(self.keysPressed) do
        self.keysDown[key] = 0
    end
end

function Input:update()
    local player = gameObjects['player']
    local camera = gameObjects['camera']

    if self.keysDown['a'] > 0 and 0 < self.keysDown['d'] or
        self.keysDown['a'] == self.keysDown['d'] then
        player:setIdle()
        
    else
        player:setWalk()
        if     self.keysDown['a'] > 0 then player.direction = -1
        elseif self.keysDown['d'] > 0 then player.direction = 1
        end
    end
    
    if (self.keysDown['q'] + self.keysDown['e']) % math.floor(FPS_LIMIT*.5) == 1 then
        local turnDirection =  -1
        if self.keysDown['q'] > self.keysDown['e'] then turnDirection = 1 end
        
        local angle = player.angle + math.pi/4 * player.direction * turnDirection
        if math.abs(angle) > math.pi/2 then
            if not player.walking then
                player.direction = player.direction *-1
                camera.center = true
            end
        else player.angle = angle end
            
    end

    for key in pairs(self.keysPressed) do self.keysPressed[key] = false end
    for key in pairs(self.keysDown) do
        if self.keysDown[key] > 0 then 
            self.keysDown[key] = self.keysDown[key] + 1
        end
    end
end

function love.keypressed(key)
    input.keysPressed[key] = true
    input.keysDown[key] = 1
end

function love.keyreleased(key)
    input.keysDown[key] = 0
end

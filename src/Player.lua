Player = Class{__includes = Entity}


function Player:init(x,y,animations,active,globalPositioning)
    Entity.init(self,x,y,globalPositioning)
    self.animations = animations
    self.active = active or false
    self.relative = false
    self.angle = 0
    self.angleToggle = true
end

function Player:update()
    Entity.update(self)

    if love.keyboard.keysPressed['a'] == love.keyboard.keysPressed['d'] then
        Player.setIdle(self)
        self.heightOffset = {1,1,1,1,1,1,0,0,0}
    else
        local relativePos = (self.pos.x - CAMERA_MARGIN.x) / (VIRTUAL_WIDTH - CAMERA_MARGIN.x * 2)
        Player.setWalk(self)
        self.heightOffset = {0,0,1,0,0,0,1,1}

        if love.keyboard.keysPressed['a'] then
            local dx = math.ceil(CAMERA_SPEED * (1-relativePos))
            self.direction = -1
            self.pos.x = self.pos.x + dx - 1
            camera.x = camera.x + dx
            flashlight:setRotation(math.pi * 7/8 - self.angle)
        
        elseif love.keyboard.keysPressed['d'] then
            local dx = math.ceil(CAMERA_SPEED * relativePos)
            self.direction = 1
            self.pos.x = self.pos.x -dx + 1
            camera.x = camera.x - dx
            flashlight:setRotation(math.pi /-8 + self.angle)
        end
    end

    if love.keyboard.keysPressed['q'] == love.keyboard.keysPressed['e'] then
        self.angleToggle = true
    else
        if love.keyboard.keysPressed['q'] and self.angleToggle then
            self.angle = math.max(math.min(self.angle + math.pi/4 * self.direction, math.pi/2), 0)
            self.angleToggle = false
        elseif love.keyboard.keysPressed['e'] and self.angleToggle  then
            self.angle = math.max(math.min(self.angle + math.pi/4 * -self.direction, math.pi/2), 0)
            self.angleToggle = false
        end
    end

    local relativePos = ((self.pos.y - CAMERA_MARGIN.y) / (VIRTUAL_HEIGHT - CAMERA_MARGIN.y * 2) - 1) * 2
    local dy = math.ceil(CAMERA_SPEED * (relativePos - self.angle/math.pi*2))
    self.pos.y = self.pos.y - dy
    camera.y = camera.y - dy
    

    flashlight.pos.x = self.pos.x + 10 * self.direction
    flashlight.pos.y = self.pos.y - 8 - self.heightOffset[math.floor(self.animation.frame+1)]
    flashlight:setRotation(math.pi*(3/8 - self.direction/2) + self.angle*self.direction) 
end

function Player:setIdle()
    self.animation = self.animations['idleFL']
end

function Player:setWalk()
    self.animation = self.animations['walkFL']
end
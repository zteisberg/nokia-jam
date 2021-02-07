Player = Class{__includes = Entity}

function Player:init(x,y,animations,active,globalPositioning)
    Entity.init(self,x,y,globalPositioning)
    self.animations = animations
    self.active = active or false
    self.relative = false
end

function Player:update()
    Entity.update(self)

    if love.keyboard.keysPressed['a'] == love.keyboard.keysPressed['d'] then
        Player.setIdle(self)
        heightOffset = {1,1,1,1,1,1,0,0,0}
    else
        local relativePos = self.x/VIRTUAL_WIDTH
        Player.setWalk(self)
        heightOffset = {0,0,1,0,0,0,1,1}

        if love.keyboard.keysPressed['a'] then
            local dx = math.floor(CAMERA_SPEED * (1-relativePos))
            self.direction = -1
            self.x = self.x + dx - 1
            globalX = globalX + dx
            flashlight:setRotation(math.pi * 7/8)
        
        elseif love.keyboard.keysPressed['d'] then
            local dx = math.floor(CAMERA_SPEED * relativePos)
            self.direction = 1
            self.x = self.x -dx + 1
            globalX = globalX - dx
            flashlight:setRotation(math.pi /-8)
        end
    end

    flashlight.x = self.x + 10 * self.direction
    flashlight.y = self.y - 8 - heightOffset[math.floor(self.animation.frame+1)]
    headlight.x = self.x + 3 * self.direction
    headlight.y = self.y - 21 - heightOffset[math.floor(self.animation.frame+1)]
end

function Player:setIdle()
    Entity.setAnimation(self, self.animations['idleFL'])
end

function Player:setWalk()
    Entity.setAnimation(self, self.animations['walkFL'])
end
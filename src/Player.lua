Player = Class{__includes = GameObject}


function Player:init(x,y,animations)
    GameObject.init(self,x,y)
    self.animations = animations
    self.angle = 0
    self.angleStore = 0
    self.flashlightOffset = nil
    self.direction = 1
    self.state = 'idle'
    self:setIdle()
end

function Player:update()
    GameObject.update(self)
    if self.state == 'stairs' then
        self.angle = math.pi/4
        if self.animation:getFrame() == #self.animation.cycle then
            self:setIdle()
            self.angle = self.angleStore
            self.pos.x = self.pos.x + 32 * self.direction
            self.pos.y = self.pos.y - 35
        end
    end
end

function Player:setIdle()
    if     self.angle == 0         then self.animation = self.animations['idleFL']
    elseif self.angle == math.pi/4 then self.animation = self.animations['idleFL45']
    elseif self.angle == math.pi/2 then self.animation = self.animations['idleFL90'] end
    self.state = 'idle'
end

function Player:setWalk()
    if     self.angle == 0         then self.animation = self.animations['walkFL']
    elseif self.angle == math.pi/4 then self.animation = self.animations['walkFL45']
    elseif self.angle == math.pi/2 then self.animation = self.animations['walkFL90'] end
    self.state = 'walking'
end

function Player:setStairsUp()
    self.animation = self.animations['stairsUpFL']
    self.animation.frame = 0
    self.state = 'stairs'
end

function Player:setStairsDown()
    self.animation = self.animations['stairsDownFL']
    self.animation.frame = 0
    self.state = 'stairs'
    self.angleStore = self.angle
end

function Player:getFlashlightX()
    return self.flashlightOffset[self.animation:getFrame()][1]
end

function Player:getFlashlightY()
    return self.flashlightOffset[self.animation:getFrame()][2]
end
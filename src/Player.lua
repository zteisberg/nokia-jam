Player = Class{__includes = GameObject}


function Player:init(x,y,animations,active,globalPositioning)
    GameObject.init(self,x,y,globalPositioning)
    self.animations = animations
    self.active = active or false
    self.angle = 0
    self.angleStore = 0
    self.heightOffset = {1,1,1,1,1,1,0,0,0}
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
    self.animation = self.animations['idleFL']
    self.state = 'idle'
end

function Player:setWalk()
    self.animation = self.animations['walkFL']
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

function Player:getHeightOffset()
    return self.heightOffset[self.animation:getFrame()]
end
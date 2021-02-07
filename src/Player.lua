Player = Class{__includes = Entity}


function Player:init(x,y,animations,active,globalPositioning)
    Entity.init(self,x,y,globalPositioning)
    self.animations = animations
    self.active = active or false
    self.relative = false
    self.angle = 0
    self.angleToggle = true
    self.heightOffset = {1,1,1,1,1,1,0,0,0}
    self:setIdle()
end

function Player:update()
    Entity.update(self)
end

function Player:setIdle()
    self.animation = self.animations['idleFL']
    self.walking = false
end

function Player:setWalk()
    self.animation = self.animations['walkFL']
    self.walking = true
end
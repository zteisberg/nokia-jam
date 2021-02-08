Player = Class{__includes = GameObject}


function Player:init(x,y,animations,active,globalPositioning)
    GameObject.init(self,x,y,globalPositioning)
    self.animations = animations
    self.active = active or false
    self.angle = 0
    self.angleToggle = true
    self.heightOffset = {1,1,1,1,1,1,0,0,0}
    self.direction = 1
    self.state = 'idle'
    self:setIdle()
end

function Player:update()
    GameObject.update(self)
    if self.state == 'walking' then
        self.pos.x = self.pos.x + self.direction
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
    self.animation = self.animations['stairsUp']
    self.state = 'stairs'
end
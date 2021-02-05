Player = Class{__includes = Entity}

function Player:init(x,y,animations,active,globalPositioning)
    Entity.init(self,x,y,globalPositioning)
    self.animations = animations
    self.active = active or false
end

function Player:update()
    Entity.update(self)

    if love.keyboard.keysPressed['a'] == love.keyboard.keysPressed['d'] then
        Player.setIdle(self)
    else
        if love.keyboard.keysPressed['a'] then
            Player.setWalk(self)
            self.direction = -1
            if self.x < VIRTUAL_WIDTH-20 then
                globalX = globalX - 1
            else  self.x = self.x - 1 end
        end
        if love.keyboard.keysPressed['d'] then
            Player.setWalk(self)
            self.direction = 1
            if self.x > 20 then
                globalX = globalX + 1
            else  self.x = self.x + 1 end
        end
    end

    if self.direction == 1 then
        if self.x > 25 then
            globalX = globalX + 1
            self.x = self.x - 1
        end
    elseif self.x < VIRTUAL_WIDTH-25 then
        globalX = globalX - 1
        self.x = self.x + 1
    end

end

function Player:setIdle()
    Entity.setAnimation(self, self.animations['idle'])
end

function Player:setWalk()
    Entity.setAnimation(self, self.animations['walk'])
end
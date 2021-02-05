Player = Class{__includes = Entity}

function Player:init(x,y,animations,active,globalPositioning)
    Entity:init(x,y,globalPositioning)
    self.animations = animations
    self.active = active or false
    Player:setIdle()
end

function Player:update()
    Entity:update()

    if love.keyboard.keysPressed['a'] == love.keyboard.keysPressed['d'] then
        Player:setIdle()
    else
        if love.keyboard.keysPressed['a'] then
            Entity:setDirection(-1)
            Player:setWalk()
            if Entity:getX() > 20 then
                Entity:move(-1,0)
            else globalX = globalX - 1 end
        end
        if love.keyboard.keysPressed['d'] then
            Entity:setDirection(1)
            Player:setWalk()
            if Entity:getX() < VIRTUAL_WIDTH - 20 then
                Entity:move(1,0)
            else globalX = globalX + 1 end
        end
    end

end

function Player:setIdle()
    Entity:setAnimation(self.animations['idle'])
end

function Player:setWalk()
    Entity:setAnimation(self.animations['walk'])
end
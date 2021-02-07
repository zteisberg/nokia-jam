Entity = Class{}

function Entity:init(x, y)
    self.relative = true
    self.direction = 1
    self.pos = {x=x, y=y}
end

function Entity:move(x, y)
    self.pos.x = self.pos.x + x
    self.pos.y = self.pos.y + y
end

function Entity:update()
    if self.animation then
        self.animation:update()
    end
end

function Entity:render()
    if self.animation then
        self.animation:render(
            math.floor(self.pos.x + (self.relative and camera.x or 0)),
            math.floor(self.pos.y + (self.relative and camera.y or 0)),
            self.direction
        )
    elseif self.sprite then
        love.graphics.draw(
            self.sprite, 
            math.floor(self.pos.x + (self.relative and camera.x or 0)), 
            math.floor(self.pos.y + (self.relative and camera.y or 0)),
            self.direction
        )
    end
end

function Entity:setRelative(relative)
    if relative and not self.relative then
        
    end

    self.relative = relative
end
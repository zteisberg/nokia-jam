Entity = Class{}

function Entity:init(x, y, globalPositioning)
    self.global = globalPositioning == nil and true or globalPositioning
    self.direction = 1
    self.x = x
    self.y = y
end

function Entity:move(x, y)
    self.x = self.x + x
    self.y = self.y + y
end

function Entity:setPosition(x, y)
    self.x = x - (self.global and globalX or 0)
    self.y = y - (self.global and globalY or 0)
end

function Entity:setDirection(direction)
    self.direction = direction
end

function Entity:setAnimation(animation)
    self.animation = animation
end

function Entity:setSprite(sprite)
    self.sprite = sprite
end

function Entity:getX()
    return self.x
end

function Entity:getY()
    return self.y
end

function Entity:update()
    if self.animation then
        self.animation:update()
    end
end

function Entity:render()
    if self.animation then
        self.animation:render(
            self.x - (self.global and globalX or 0),
            self.y - (self.global and globalY or 0),
            self.direction
        )
    elseif self.sprite then
        love.graphics.draw(
            self.sprite, 
            self.x - (self.global and globalX or 0), 
            self.y - (self.global and globalY or 0)
        )
    end
end
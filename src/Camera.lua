Camera = Class{__includes = Entity}

function Camera:init(x,y,speed, xMargin, yMargin)
    Entity.init(self, x, y)
    self.speed = speed
    self.margin = {x=xMargin, y=yMargin}
    self.center = false
end

function Camera:update()
    local player = gameObjects['player']

    local relativePos = {
        x = (player.pos.x - self.margin.x) / (VIRTUAL_WIDTH - self.margin.x * 2),
        y = ((player.pos.y - self.margin.y) / (VIRTUAL_HEIGHT - self.margin.y * 2) - 1) * 2
    }

    local d = {
        x = math.floor(self.speed * (relativePos.x + (player.direction - 1) * .5) + .5),
        y = math.floor(self.speed * (relativePos.y - player.angle / math.pi * 2)  + .5)
    }

    if player.walking then
        self.pos.x = self.pos.x - d.x
        player.pos.x = player.pos.x - d.x + player.direction

    elseif self.center then
        self.pos.x = self.pos.x - math.floor(d.x/2)
        player.pos.x = player.pos.x - math.floor(d.x/2)
        if math.abs(d.x) <= 6 then self.center = false end
    end
    
    self.pos.y = self.pos.y - d.y
    player.pos.y = player.pos.y - d.y
end


-- local relativePos = ((self.pos.y - CAMERA_MARGIN.y) / (VIRTUAL_HEIGHT - CAMERA_MARGIN.y * 2) - 1) * 2
-- local dy = math.ceil(CAMERA_SPEED * (relativePos - self.angle/math.pi*2))
-- self.pos.y = self.pos.y - dy
-- camera.y = camera.y - dy

function Camera:render()
    --do nothing
end